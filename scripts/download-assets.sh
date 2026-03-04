#!/bin/bash
# Downloads all external assets (badges, stats cards) and saves them locally.
# Run this script whenever you want to refresh badges or add new ones.
# The GitHub Action workflow also calls this to keep stats images fresh.

set -euo pipefail

ASSETS_DIR="$(cd "$(dirname "$0")/../assets" && pwd)"
mkdir -p "$ASSETS_DIR/badges" "$ASSETS_DIR/stats"

echo "📥 Downloading badges..."

# --- Offensive Security Badges ---
declare -A OFFENSIVE=(
  ["cobalt-strike"]="Cobalt_Strike-000?style=for-the-badge&logo=target&logoColor=FF0000"
  ["metasploit"]="Metasploit-000?style=for-the-badge&logo=metasploit&logoColor=2596CD"
  ["burp-suite"]="Burp_Suite-000?style=for-the-badge&logo=burpsuite&logoColor=FF6633"
  ["nmap"]="Nmap-000?style=for-the-badge&logo=nmap&logoColor=00C853"
  ["wireshark"]="Wireshark-000?style=for-the-badge&logo=wireshark&logoColor=1679A7"
  ["mitre-attack"]="MITRE_ATT%26CK-000?style=for-the-badge&logo=target&logoColor=FF0000"
  ["kali-linux"]="Kali_Linux-000?style=for-the-badge&logo=kalilinux&logoColor=557C94"
  ["caldera"]="CALDERA-000?style=for-the-badge&logo=target&logoColor=FF6633"
)

# --- Language Badges ---
declare -A LANGUAGES=(
  ["python"]="Python-000?style=for-the-badge&logo=python"
  ["go"]="Go-000?style=for-the-badge&logo=go"
  ["c"]="C-000?style=for-the-badge&logo=c&logoColor=A8B9CC"
  ["bash"]="Bash-000?style=for-the-badge&logo=gnubash&logoColor=4EAA25"
  ["powershell"]="PowerShell-000?style=for-the-badge&logo=powershell&logoColor=5391FE"
  ["javascript"]="JavaScript-000?style=for-the-badge&logo=javascript"
  ["sql"]="SQL-000?style=for-the-badge&logo=mysql&logoColor=4479A1"
)

# --- Tools Badges ---
declare -A TOOLS=(
  ["linux"]="Linux-000?style=for-the-badge&logo=linux&logoColor=FCC624"
  ["docker"]="Docker-000?style=for-the-badge&logo=docker"
  ["git"]="Git-000?style=for-the-badge&logo=git"
  ["github-actions"]="GitHub_Actions-000?style=for-the-badge&logo=githubactions"
  ["vmware"]="VMware-000?style=for-the-badge&logo=vmware&logoColor=607078"
  ["aws"]="AWS-000?style=for-the-badge&logo=amazonaws&logoColor=FF9900"
  ["ansible"]="Ansible-000?style=for-the-badge&logo=ansible&logoColor=EE0000"
)

# --- Project Badges ---
declare -A PROJECTS=(
  ["dpapi-bof"]="🩸_DPAPI__BOF-Cobalt_Strike_BOFs-FF0000?style=for-the-badge&labelColor=000"
  ["esxibrute"]="⚔️_ESXiBrute-ESXi_Credential_Testing-FF0000?style=for-the-badge&labelColor=000"
  ["jenkinsvulnfinder"]="🔍_JenkinsVulnFinder-Jenkins_Scanner-FF0000?style=for-the-badge&labelColor=000"
  ["vmwareapipentest"]="🛰️_VMwareAPIPentest-SOAP_API_Tester-FF0000?style=for-the-badge&labelColor=000"
  ["calderaagent"]="🕵️_CalderaAgent-Go_Linux_Implant-FF0000?style=for-the-badge&labelColor=000"
  ["agentic-seo"]="🤖_Agentic_SEO_Skill-LLM_SEO_Analysis-58A6FF?style=for-the-badge&labelColor=000"
)

# --- Social Badges ---
declare -A SOCIAL=(
  ["hackingdream"]="HackingDream.net-FF0000?style=for-the-badge&logo=googlechrome&logoColor=white"
  ["github"]="GitHub-181717?style=for-the-badge&logo=github&logoColor=white"
  ["linkedin"]="LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white"
)

download_badges() {
  local -n badge_map=$1
  for name in "${!badge_map[@]}"; do
    local url="https://img.shields.io/badge/${badge_map[$name]}"
    local file="$ASSETS_DIR/badges/${name}.svg"
    if curl -sfL "$url" -o "$file"; then
      echo "  ✅ $name"
    else
      echo "  ❌ Failed: $name"
    fi
  done
}

download_badges OFFENSIVE
download_badges LANGUAGES
download_badges TOOLS
download_badges PROJECTS
download_badges SOCIAL

echo ""
echo "📥 Downloading separator..."
curl -sfL "https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif" -o "$ASSETS_DIR/separator.gif" && echo "  ✅ separator.gif" || echo "  ❌ separator.gif"

echo ""
echo "📥 Downloading stats cards..."
USERNAME="${1:-Bhanunamikaze}"

# GitHub Readme Stats (using sigma-five fork since default deployment is paused)
curl -sfL "https://github-readme-stats-sigma-five.vercel.app/api?username=${USERNAME}&show_icons=true&theme=radical&hide_border=true&count_private=true&include_all_commits=true&bg_color=0D1117&title_color=FF6B6B&icon_color=FF6B6B&text_color=C9D1D9&ring_color=FF0000" -o "$ASSETS_DIR/stats/github-stats.svg" && echo "  ✅ github-stats.svg" || echo "  ❌ github-stats.svg"

# Profile Summary Cards
curl -sfL "http://github-profile-summary-cards.vercel.app/api/cards/profile-details?username=${USERNAME}&theme=radical" -o "$ASSETS_DIR/stats/profile-details.svg" && echo "  ✅ profile-details.svg" || echo "  ❌ profile-details.svg"
curl -sfL "http://github-profile-summary-cards.vercel.app/api/cards/stats?username=${USERNAME}&theme=radical" -o "$ASSETS_DIR/stats/stats-card.svg" && echo "  ✅ stats-card.svg" || echo "  ❌ stats-card.svg"
curl -sfL "http://github-profile-summary-cards.vercel.app/api/cards/repos-per-language?username=${USERNAME}&theme=radical" -o "$ASSETS_DIR/stats/repos-per-language.svg" && echo "  ✅ repos-per-language.svg" || echo "  ❌ repos-per-language.svg"
curl -sfL "http://github-profile-summary-cards.vercel.app/api/cards/most-commit-language?username=${USERNAME}&theme=radical" -o "$ASSETS_DIR/stats/most-commit-language.svg" && echo "  ✅ most-commit-language.svg" || echo "  ❌ most-commit-language.svg"

echo ""
echo "✅ All assets downloaded to $ASSETS_DIR/"
echo "   badges/  — $(ls "$ASSETS_DIR/badges/" | wc -l) badge SVGs"
echo "   stats/   — $(ls "$ASSETS_DIR/stats/" | wc -l) stat card SVGs"
