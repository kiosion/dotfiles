# Simple script to pull specified webtoons from webtoons.com
# TODO: Better error handling, batch downloading, filename templating

import requests
from bs4 import BeautifulSoup
import argparse
from PIL import Image
from io import BytesIO
import os
import re
import sys
import zipfile
from multiprocessing import Pool

# Default download dir is '~/webtoons-dl'
download_dir = os.path.expanduser('~/webtoons-dl')
comic_title = None


def find_episode_urls(url):
    global download_dir
    global comic_title

    r = requests.get(url)
    if r.status_code != 200:
        r.raise_for_status()

    soup = BeautifulSoup(r.text, 'html.parser')

    _comic_title = soup.find('h1', class_='subj').text
    _comic_title = _comic_title.lower().replace(' ', '-')

    comic_title = _comic_title

    if comic_title is None:
        print('Could not find comic title, exiting...')
        return

    download_dir = os.path.join(download_dir, comic_title)

    pagination = soup.find('div', class_='paginate')
    page_links = pagination.find_all('a')

    data = []
    for page in range(len(page_links), 0, -1):
        print(f'Getting episode list for page {page}...')

        url = page_links[page - 1]['href']
        if url == '#':
            url = r.url
        else:
            url = 'https://www.webtoons.com' + url
        episodes = get_episode_list(url)
        data.extend(episodes)

    return data


def get_episode_list(url):
    # Get list of episode urls from a given url (will be 'a' tags
    # within 'li' tags with id 'episode_1', etc.)
    r = requests.get(url)
    if r.status_code != 200:
        r.raise_for_status()

    soup = BeautifulSoup(r.text, 'html.parser')

    episodes = soup.find_all('li', id=lambda x: x and x.startswith('episode_'))

    data = []
    for episode in episodes[::-1]:
        e_id = episode['id'].split('_')[1]
        e_href = episode.find('a')['href']
        e_name = episode.find('a').find('span', class_='subj').text
        data.append((e_id, e_name, e_href))

    return data


def get_episode_images(url):
    # Download all images for given episode URL
    print(f'Fetching images from {url}...')

    r = requests.get(url)
    if r.status_code != 200:
        r.raise_for_status()

    soup = BeautifulSoup(r.text, 'html.parser')
    images = soup.find_all('img', class_='_images')

    data = []
    for image in images[::-1]:
        src = image.get('data-url')

        r = requests.get(src, headers={'referer': 'https://www.webtoons.com'})
        if r.status_code != 200:
            r.raise_for_status()

        pil_image = Image.open(BytesIO(r.content))
        data.append(pil_image)

    return stitch_images(data)


def batch_images(episodes, max_pool_size):
    pool = Pool(processes=min(len(episodes), max_pool_size))
    results = pool.map(get_episode_images, [e[2] for e in episodes])
    pool.close()
    pool.join()
    images = []
    for result in results:
        images.append(result)
    return images


def download_episodes(episodes):
    global download_dir

    if not os.path.exists(download_dir):
        os.makedirs(download_dir)
    elif not os.path.isdir(download_dir):
        print('Invalid download directory, exiting...')
        return

    print(f'Ready to download {len(episodes)} episodes to {download_dir}')
    print('Press enter to continue...')
    input()

    max_batch_size = min(8, int(os.cpu_count() / 2))

    try:
        for i in range(0, len(episodes), max_batch_size):
            batch = episodes[i:i + max_batch_size]
            images = batch_images(batch, max_batch_size)

            for j, image in enumerate(images):
                clean_name = re.sub(r'\s+', ' ', batch[j][1].strip())
                clean_name = re.sub(
                    r'[^a-zA-Z0-9\s\-\_\.\(\)\#]+', '', clean_name
                )

                filename = os.path.join(
                    download_dir, f'{batch[j][0]}. {clean_name}.jpg'
                )

                image.save(filename, 'JPEG')
                print(f'Saved "{filename}"')
    except Exception as e:
        print('Error downloading images, exiting...')
        print(e)
        return


def stitch_images(images):
    width = max([image.width for image in images])
    height = sum([image.height for image in images])

    stitched_image = Image.new('RGB', (width, height))

    y_offset = 0
    for pil_image in images[::-1]:
        stitched_image.paste(pil_image, (0, y_offset))
        y_offset += pil_image.height

    return stitched_image


def zip_images():
    global download_dir

    files = os.listdir(download_dir)

    zip_path = os.path.join(download_dir, 'images.zip')
    zip_file = zipfile.ZipFile(zip_path, 'w')

    for file in files:
        zip_file.write(os.path.join(download_dir, file), file)
        os.remove(os.path.join(download_dir, file))

    zip_file.close()
    print(f'Zipped images to {zip_path}')


def main():
    global download_dir

    parser = argparse.ArgumentParser()
    parser.add_argument('--url', help='URL of webtoon to download')
    parser.add_argument('url', nargs='?', help='URL of webtoon to download')
    parser.add_argument('--dir', help='Directory to save images to')
    parser.add_argument('--zip', help='Zip images into single file when done')
    args = parser.parse_args()

    url = args.url
    dir = args.dir

    if dir is None:
        print(f'No directory provided, defaulting to "{download_dir}"...')
    else:
        download_dir = dir

    valid_url = re.compile(r"""https?:\/\/(?:www\.)?webtoons\.com\/
                               [a-zA-Z]{2}\/.*?\/.*?\/list\?
                               (?:title_no|.*?&title_no)=\d+.*""", re.X)

    if not re.match(valid_url, url):
        print('Invalid URL provided - URL should be of the form:')
        print(
            'https://www.webtoons.com/en/genre/comic-title/list?title_no=0000'
        )
        return

    try:
        episodes = find_episode_urls(url)
    except Exception as e:
        print(f'Uncaught error: {e}')
        return

    try:
        result = download_episodes(episodes)
    except Exception as e:
        print(f'Uncaught error: {e}')
        return

    if result and args.zip:
        print('Zipping images...')
        zip_images()

    print('Done!')


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\r', end='')
        print('Exiting...')
        sys.exit(0)
