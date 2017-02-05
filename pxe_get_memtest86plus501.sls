{% set basepath = '/srv/tftp' %}

{{ basepath }}sysimages/memtest:
  archive.extracted:
    - source: http://www.memtest.org/download/5.01/memtest86+-5.01.zip
    - source_hash: 595679f5b6a34a92b1fe696554e4e0f4f44f12a4b1bb6e18283caaf1ef31b863 
    - user: root
    - group: root
    - enforce_toplevel: False
    - extract_perms: False

memtest_dir_create:
  file.directory:
    - name: {{ basepath }}/sysimages/memtest
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

{{ basepath }}/sysimages/memtest:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True


{{ basepath }}/pxelinux.cfg/default:
  file.blockreplace:
    - marker_start: "# START memtest86+-5.01.bin"
    - marker_end: "# END memtest86+-5.01.bin"
    - show_changes: True
    - append_if_not_found: True
    - content: |
        LABEL      memtest
        MENU LABEL ^Memtest86+ v5.01
        KERNEL     sysimages/memtest/memtest86plus501
cp -afl {{ basepath }}/sysimages/memtest/memtest86+-5.01.bin {{ basepath }}/sysimages/memtest/memtest86plus501:
  cmd.run

