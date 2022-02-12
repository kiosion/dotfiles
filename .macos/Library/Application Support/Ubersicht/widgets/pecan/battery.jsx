const command = "bash pecan/scripts/battery";
const refreshFrequency = 2000; // ms

const render = ({ output }) => <div class='screen'><div class='pecanbattery'>{`${output}`}</div></div>;

export { command, refreshFrequency, render };
