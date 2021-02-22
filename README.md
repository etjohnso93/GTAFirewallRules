# GTAFirewallRules
Scripts to setup a public solo or friends only GTA 5 session

# Prereqs
Edit the GTA5FirewallSetup file to include any list of ip's you wish to whilelist
(leave blank for solo public session)
**Example:**

![Alt text](ScreenShots/whitelistExample.png?raw=true)

**Update the GTAFirewallSetup file to point to wherever GTA5 is installed.  To find the path:
with GTA 5 running, open task manager and right-click GTA5 and go to properties:**

![Alt text](ScreenShots/taskmanagerexample.png?raw=true)

**Copy the Location and paste it into the $gta5Path:**

![Alt text](ScreenShots/pathexample.png?raw=true)

![Alt text](ScreenShots/codepathexample.png?raw=true)



# Execution
Run the FirewallSetup.bat as administrator

Now you should see new firewall rules with the appropriate settings:
![Alt text](ScreenShots/outboundruleexample.png?raw=true)
