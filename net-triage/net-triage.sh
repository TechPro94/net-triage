#!/bin/zsh
LOG="$HOME/Desktop/net_troubleshoot_$(date +%Y%m%d_%H%M%S).txt"
sec(){ echo "=== $1 === $(date)"; }

{
  sec "PRE"
  ifconfig
  scutil --dns
  ping -c5 1.1.1.1
  nc -vz www.microsoft.com 443
  nc -vz outlook.office365.com 443
  netstat -rn

  sec "ACTIONS"
  echo "Flushing DNS cache..."
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder || true
  echo "Renewing DHCP on default interface..."
  primary_if=$(route get default 2>/dev/null | awk '/interface:/{print $2}')
  [ -n "$primary_if" ] && sudo ipconfig set "$primary_if" DHCP 2>/dev/null || true

  sec "POST"
  ifconfig
  ping -c5 1.1.1.1
  nc -vz login.microsoftonline.com 443
  nc -vz outlook.office365.com 443

  sec "SUMMARY"
  echo "Log saved to: $LOG"
} > "$LOG" 2>&1

echo "Done. Review log -> $LOG"
