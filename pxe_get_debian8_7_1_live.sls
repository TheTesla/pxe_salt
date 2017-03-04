{% set basepath = '/srv/tftp' %}
{% set isoname = 'debian-live-8.7.1-amd64-standard.iso' %}
{% set sysdirname = 'debian_live_8_7_1_amd64_standard' %}
{% set labelname = sysdirname %}



{{ basepath }}/sysimages/{{ sysdirname }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

{{ basepath }}/sysimages/{{ sysdirname }}/{{ isoname }}:
  file.managed:
    - source: http://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/{{ isoname }}
    - source_hash: http://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/SHA256SUMS
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
        LABEL      {{ labelname }}
        MENU LABEL ^{{ labelname }}
        KERNEL     sysimages/{{ sysdirname }}/live/vmlinuz
        APPEND     root=/dev/nfs nfsroot=172.23.92.251:{{ basepath }}/sysimages/{{ sysdirname }} fetch=tftp://172.23.92.251/sysimages/{{ sysdirname }}/live/filesystem.squashfs netboot=nfs ro initrd=/sysimages/{{ sysdirname }}/live/initrd.img locale=de_DE bootkbd=de console-setup/layoutcode=de ip=dhcp boot=live -- 
 

