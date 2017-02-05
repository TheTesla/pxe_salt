{% set basepath = '/srv/tftp' %}

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

{{ basepath }}/regex_tftpd:
  file.managed:
    - source: salt://regex_tftpd
    - user: root
    - group: root
    - mode: 644

/etc/default/tftpd-hpa:
  file.managed:
    - source: salt://tftpd-hpa.conf
    - user: root
    - group: root
    - mode: 644

{{ basepath }}/sysimages:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
{{ basepath }}/pxelinux.0:
  file.copy:
    - source: /usr/lib/PXELINUX/pxelinux.0
    - makedirs: True
cp -rf /usr/lib/syslinux/modules/bios/* {{ basepath }}/.:
  cmd.run
default_exists:
  file.touch:
    - name: {{ basepath }}/pxelinux.cfg/default
    - makedirs: True
{{ basepath }}/pxelinux.cfg/default:
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


/etc/exports:
  file.blockreplace:
    - marker_start: "# START pxe directory"
    - marker_end: "# END pxe directory"
    - show_changes: True
    - append_if_not_found: True
    - content: |
        {{ basepath }}    *(ro,no_subtree_check,no_root_squash,insecure)

