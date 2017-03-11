{% set basepath = '/srv/tftp' %}
{% set urlpath = 'http://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid' %}
{% set isoname = 'debian-live-8.7.1-amd64-standard.iso' %}
{% set sysdirname = 'debian-live-8.7.1-amd64-standard' %}
{% set labelname = 'Debian Live 8.7.1 amd64 Standard' %}



{{ basepath }}/sysimages/{{ sysdirname }}/{{ isoname }}:
  file.managed:
    - source: {{ urlpath }}/{{ isoname }}
    - source_hash: {{ urlpath }}/SHA256SUMS
    - makedirs: True
    - user: root
    - group: root

/mnt/{{ sysdirname }}:
  mount.mounted:
    - device: {{ basepath }}/sysimages/{{ sysdirname }}/{{ isoname }}
    - fstype: iso9660
    - mkmnt: True
    - opts:
      - defaults

cp -rf /mnt/{{ sysdirname }}/* {{ basepath }}/sysimages/{{ sysdirname }}/.:
  cmd.run


{{ basepath }}/pxelinux.cfg/default:
  file.blockreplace:
    - marker_start: "# START {{ sysdirname }}"
    - marker_end: "# END {{ sysdirname }}"
    - show_changes: True
    - append_if_not_found: True
    - content: |
        LABEL      {{ sysdirname }}
        MENU LABEL ^{{ labelname }}
        KERNEL     sysimages/{{ sysdirname }}/live/vmlinuz
        APPEND     root=/dev/nfs fetch=tftp://172.23.92.251/sysimages/{{ sysdirname }}/live/filesystem.squashfs netboot=nfs ro initrd=/sysimages/{{ sysdirname }}/live/initrd.img locale=de_DE bootkbd=de console-setup/layoutcode=de ip=dhcp boot=live -- 
 
