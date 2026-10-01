#!/usr/bin/env bash

SYSTEM_STATUS_CPU='?'
SYSTEM_STATUS_MEM='?'
SYSTEM_STATUS_DISK='?'

system_status_human_bytes() {
  local bytes=$1 divisor=1 unit='' next scaled decimal rounding

  for next in K M G T P E; do
    ((bytes < divisor * 1024)) && break
    divisor=$((divisor * 1024))
    unit=$next
  done

  rounding=$((divisor / 2))
  [[ ${2:-} == --round-up ]] && rounding=$((divisor - 1))

  if ((bytes < divisor * 10)); then
    scaled=$(((bytes * 10 + rounding) / divisor))
    decimal=$((scaled - scaled / 10 * 10))
    SYSTEM_STATUS_HUMAN="$((scaled / 10)).${decimal}${unit}"
  else
    SYSTEM_STATUS_HUMAN="$(((bytes + rounding) / divisor))${unit}"
  fi
}

system_status_format_cpu() {
  local usage=$1

  ((usage >= 0 && usage <= 100)) || return
  if ((usage < 10 || usage >= 100)); then
    SYSTEM_STATUS_CPU=" $usage%"
  else
    SYSTEM_STATUS_CPU="$usage%"
  fi
}

system_status_set_cpu_from_idle() {
  local idle=$1 whole fraction usage

  IFS=. read -r whole fraction <<< "$idle"
  [[ $whole =~ ^[0-9]+$ ]] || return
  usage=$((100 - 10#$whole))
  [[ $fraction == *[1-9]* ]] && ((usage--))
  system_status_format_cpu "$usage"
}

system_status_collect_cpu_darwin() {
  local output idle='' fields

  output=$(/usr/sbin/iostat -d -C -c 2 -n 0 -w 1) || return
  while read -ra fields; do
    [[ ${fields[0]} =~ ^[0-9] ]] && idle=${fields[${#fields[@]} - 1]}
  done <<< "$output"

  [[ -n $idle ]] && system_status_set_cpu_from_idle "$idle"
}

system_status_read_linux_cpu() {
  local user nice system idle iowait irq softirq steal

  read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat || return
  SYSTEM_STATUS_CPU_TOTAL=$((user + nice + system + idle + iowait + irq + softirq + steal))
  SYSTEM_STATUS_CPU_IDLE=$((idle + iowait))
}

system_status_collect_cpu_linux() {
  local previous_total previous_idle total_delta idle_delta usage

  system_status_read_linux_cpu || return
  previous_total=$SYSTEM_STATUS_CPU_TOTAL
  previous_idle=$SYSTEM_STATUS_CPU_IDLE
  sleep 1
  system_status_read_linux_cpu || return
  total_delta=$((SYSTEM_STATUS_CPU_TOTAL - previous_total))
  idle_delta=$((SYSTEM_STATUS_CPU_IDLE - previous_idle))
  ((total_delta > 0)) || return
  usage=$(((200 * (total_delta - idle_delta) + total_delta) / (2 * total_delta)))
  system_status_format_cpu "$usage"
}

system_status_collect_mem_darwin() {
  local output name value pagesize=0 free_pages=0 active=0 inactive=0
  local speculative=0 wired=0 compressed=0 purgeable=0 file_backed=0
  local used_counted used_bytes total_bytes used

  output=$(/usr/bin/vm_stat) || return
  while IFS=: read -r name value; do
    value=${value//[!0-9]/}
    case $name in
      'Mach Virtual Memory Statistics') pagesize=$value ;;
      'Pages free') free_pages=$value ;;
      'Pages active') active=$value ;;
      'Pages inactive') inactive=$value ;;
      'Pages speculative') speculative=$value ;;
      'Pages wired down') wired=$value ;;
      'Pages occupied by compressor') compressed=$value ;;
      'Pages purgeable') purgeable=$value ;;
      'File-backed pages') file_backed=$value ;;
    esac
  done <<< "$output"

  ((pagesize > 0)) || return
  used_counted=$((active + inactive + speculative + wired + compressed))
  ((used_counted >= purgeable + file_backed)) || return
  used_bytes=$(((used_counted - purgeable - file_backed) * pagesize))
  total_bytes=$(((used_counted + free_pages) * pagesize))
  ((total_bytes > 0)) || return

  system_status_human_bytes "$used_bytes"
  used=$SYSTEM_STATUS_HUMAN
  system_status_human_bytes "$total_bytes"
  SYSTEM_STATUS_MEM="$used/$SYSTEM_STATUS_HUMAN"
}

system_status_collect_mem_linux() {
  local name value mem_total_kib=0 mem_available_kib='' mem_free_kib=0
  local buffers_kib=0 cached_kib=0 reclaimable_kib=0 shmem_kib=0
  local mem_used_kib used

  while read -r name value _; do
    case $name in
      MemTotal:) mem_total_kib=$value ;;
      MemAvailable:) mem_available_kib=$value ;;
      MemFree:) mem_free_kib=$value ;;
      Buffers:) buffers_kib=$value ;;
      Cached:) cached_kib=$value ;;
      SReclaimable:) reclaimable_kib=$value ;;
      Shmem:) shmem_kib=$value ;;
    esac
  done < /proc/meminfo

  ((mem_total_kib > 0)) || return
  [[ -n $mem_available_kib ]] ||
    mem_available_kib=$((mem_free_kib + buffers_kib + cached_kib + reclaimable_kib - shmem_kib))
  ((mem_available_kib < 0)) && mem_available_kib=0
  ((mem_available_kib > mem_total_kib)) && mem_available_kib=$mem_total_kib
  mem_used_kib=$((mem_total_kib - mem_available_kib))

  system_status_human_bytes "$((mem_used_kib * 1024))"
  used=$SYSTEM_STATUS_HUMAN
  system_status_human_bytes "$((mem_total_kib * 1024))"
  SYSTEM_STATUS_MEM="$used/$SYSTEM_STATUS_HUMAN"
}

system_status_collect_disk() {
  local output disk_total disk_used disk_available used

  output=$(df -Pk /) || return
  {
    read -r
    read -r _ disk_total disk_used disk_available _ || return
  } <<< "$output"
  [[ $disk_total =~ ^[0-9]+$ && $disk_used =~ ^[0-9]+$ ]] || return

  if [[ ${OSTYPE:-} == darwin* ]]; then
    # APFS shares available space across volumes; Used may count only /.
    [[ $disk_available =~ ^[0-9]+$ ]] || return
    disk_used=$((disk_total - disk_available))
  fi
  ((disk_total > 0 && disk_used >= 0)) || return

  system_status_human_bytes "$((disk_used * 1024))" --round-up
  used=$SYSTEM_STATUS_HUMAN
  system_status_human_bytes "$((disk_total * 1024))" --round-up
  SYSTEM_STATUS_DISK="$used/$SYSTEM_STATUS_HUMAN"
}

system_status_collect() {
  case ${OSTYPE:-} in
    darwin*)
      system_status_collect_cpu_darwin
      system_status_collect_mem_darwin
      ;;
    linux*)
      system_status_collect_cpu_linux
      system_status_collect_mem_linux
      ;;
    *)
      if [[ -r /proc/stat ]]; then
        system_status_collect_cpu_linux
        system_status_collect_mem_linux
      else
        return
      fi
      ;;
  esac
  system_status_collect_disk
}

system_status_collect
if [[ ${1:-} == --compact ]]; then
  printf '%s|%s|%s\n' "$SYSTEM_STATUS_CPU" "$SYSTEM_STATUS_MEM" "$SYSTEM_STATUS_DISK"
  exit
fi

if ((BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 2))); then
  printf -v datetime '%(%m/%d %H:%M %Z)T' -1
else
  datetime=$(date '+%m/%d %H:%M %Z')
fi

printf '󰃰 %s ·  %s ·  %s · 󰋊 %s · 󰒋 %s\n' \
  "$datetime" "$SYSTEM_STATUS_CPU" "$SYSTEM_STATUS_MEM" "$SYSTEM_STATUS_DISK" "$HOSTNAME"
