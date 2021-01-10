# build_winpe3.0_setup_pxe_with_win_tftp
 Builds WinPE 3.0 and prepares TFTP-Folder (Windows tftp-Server)


# Requirements

Windows PC with installed:
* WAIK - Windows Automated Installation Kit (AIK) for Windows 7
  * source: (http://www.microsoft.com/downloads/details.aspx?displaylang=en&FamilyID=696dd665-9f76-4177-a811-39c26d3b3b34)
* tftpd32 (http://tftpd32.jounin.net/tftpd32_download.html)
  * running @ C:\tftp
  * otherwise change %TFTPPath% in bat-File
* pxelinux.0 
  * from https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.zip @**(bios\core\pxelinux.0)**
  * or from http://archive.ubuntu.com/ubuntu/dists/xenial/main/installer-amd64/current/images/netboot/pxelinux.0 **(x86 and amd64 are identical)**
  

# Instructions

0. copy pxelinux.0 and folder pxelinux.cfg to C:\tftp

1. Run Deployment Tools CMD

    As you already know, we have to have WAIK installed on our system. WAIK contains Deployment Tools CMD which we will use to create our WinPE ISO.
    **To run Deployment Tools CMD go to**
    > Start > All Programs > Microsoft Windows AIK > Deployment Tools Command Prompt

2. run the script (full_winpe_3.0_amd64_2016_fixed_pxelinux.bat) **within the WAIK Deployment tools command prompt**
    > .\full_winpe_3.0_amd64_2016_fixed_pxelinux.bat

3. with the script completed all files should be at %TFTPPath% (C:\tftp & C:\tftp\boot)

4. configure tftpd32

    TFTP-Settings
    ![tftpd32 - tftp setttings](./assets/tftpd32_-_tftp_settings.png?raw=true "tftpd32 - tftp setttings")
    Option negotiation is enabled

    DHCP-Settings
    ![tftpd32 - dhcp setttings](./assets/tftpd32_-_dhcp_settings.png?raw=true "tftpd32 - dhcp setttings")
    Boot File = ./pxelinux.0

5. make sure firewall allows traffic
6. boot the client machine with pxe (usally F12 PXE/Network Boot) - if option is not available enable it in bios/uefi (not all machines feature pxe boot!)