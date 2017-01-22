syslinux:
  pkg:
    - installed
pxelinux:
  pkg:
    - installed
tftpd-hpa:
  pkg:
    - installed
  service:
    - enabled
nfs-kernel-server:
  pkg:
    - installed
  service:
    - enabled

/srv/tftp:
  file.recurse:
    - source: salt://bootfiles
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - include_empty: True
cp -rf /usr/lib/syslinux/modules/bios /srv/tftp/.:
  cmd.run
/srv/tftp/bios/pxelinux.0:
  file.copy:
    - source: /usr/lib/PXELINUX/pxelinux.0
    - makedirs: True
default_exists:
  file.touch:
    - name: /srv/tftp/bios/pxelinux.cfg/default
    - makedirs: True
/srv/tftp/bios/pxelinux.cfg/default:
  file.blockreplace:
    - marker_start: "# START default"
    - marker_end: "# END default"
    - show_changes: True
    - prepend_if_not_found: True
    - content: |
        DEFAULT vesamenu.c32
        ALLOWOPTIONS 0
        PROMPT 0
        TIMEOUT 0

        MENU TITLE Server PXE Boot Menu


