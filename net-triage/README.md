# Network Triage (Windows + macOS)

Collect → Fix → Collect. Captures pre/post state and applies safe network fixes (DNS flush, Winsock/TCP reset, DHCP renew). Outputs a single log file for tickets or vendors.

## Usage

### Windows (PowerShell)
```powershell
powershell -ExecutionPolicy Bypass -File .\net-triage.ps1
```

### macOS (zsh)
```bash
chmod +x ./net-triage.sh
./net-triage.sh
```

> ⚠️ Sanitized demo scripts — no real credentials or company data.
