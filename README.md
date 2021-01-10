# build_winpe3.0_setup_pxe_with_win_tftp
 Builds WinPE 3.0 and prepares TFTP-Folder (Windows tftp-Server)


# Requirements

Windows PC with installed:
* WAIK - Windows Automated Installation Kit (AIK) for Windows 7 (http://www.microsoft.com/downloads/details.aspx?displaylang=en&FamilyID=696dd665-9f76-4177-a811-39c26d3b3b34)
* tftpd32 (http://tftpd32.jounin.net/tftpd32_download.html)
** running @ C:\tftp
** otherwise change %TFTPPath% in bat-File


# Instructions

1. Run Deployment Tools CMD

As you already know, we have to have WAIK installed on our system. WAIK contains Deployment Tools CMD which we will use to create our WinPE ISO. To run Deployment Tools CMD go to Start > All Programs > Microsoft Windows AIK > Deployment Tools Command Prompt.

2. run the script (full_winpe_3.0_amd64_2016_fixed_pxelinux.bat) within the WAIK Deployment tools command prompt
.\full_winpe_3.0_amd64_2016_fixed_pxelinux.bat

3. with the script completed all files should be at %TFTPPath% (C:\tftp & C:\tftp\boot)

4. configure tftpd32

![tftpd32 - tftp setttings](./assets/tftpd32_-_tftp_settings.png?raw=true "tftpd32 - tftp setttings")
Option negotiation is enabled

![tftpd32 - dhcp setttings](./assets/tftpd32_-_dhcp_settings.png?raw=true "tftpd32 - dhcp setttings")
Boot File = ./pxelinux.0