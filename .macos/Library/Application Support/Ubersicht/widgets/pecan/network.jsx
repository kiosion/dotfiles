const command = "bash pecan/scripts/network";
const refreshFrequency = 4000; // ms

const render = ({ output }) => <div class='screen'><div class='pecannetwork'>{`${output}`}</div></div>;

export { command, refreshFrequency, render };
