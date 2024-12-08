local apps <const> = {
    ["Live"] = ":ableton:",
    ["Adobe Bridge 2024"] = ":adobe_bridge:",
    ["Affinity Designer"] = ":affinity_designer:",
    ["Affinity Designer 2"] = ":affinity_designer_2:",
    ["Affinity Photo"] = ":affinity_photo:",
    ["Affinity Photo 2"] = ":affinity_photo_2:",
    ["Affinity Publisher"] = ":affinity_publisher:",
    ["Affinity Publisher 2"] = ":affinity_publisher_2:",
    ["Airmail"] = ":airmail:",
    ["Alacritty"] = ":alacritty:",
    ["Alfred Preferences"] = ":alfred:",
    ["Android Messages"] = ":android_messages:",
    ["Android Studio"] = ":android_studio:",
    ["Anytype"] = ":anytype:",
    ["App Eraser"] = ":app_eraser:",
    ["App Store"] = ":app_store:",
    ["Arc"] = ":arc:",
    ["Atom"] = ":atom:",
    ["Audacity"] = ":audacity:",
    ["Bambu Studio"] = ":bambu_studio:",
    ["MoneyMoney"] = ":bank:",
    ["Bear"] = ":bear:",
    ["BetterTouchTool"] = ":bettertouchtool:",
    ["Bilibili"] = ":bilibili:",
    ["哔哩哔哩"] = ":bilibili:",
    ["Bitwarden"] = ":bit_warden:",
    ["Blender"] = ":blender:",
    ["BluOS Controller"] = ":bluos_controller:",
    ["Calibre"] = ":book:",
    ["Brave Browser"] = ":brave_browser:",
    ["Calculator"] = ":calculator:",
    ["Soulver 3"] = ":calculator:",
    ["Calculette"] = ":calculator:",
    ["Calendar"] = ":calendar:",
    ["日历"] = ":calendar:",
    ["Fantastical"] = ":calendar:",
    ["Cron"] = ":calendar:",
    ["Amie"] = ":calendar:",
    ["Calendrier"] = ":calendar:",
    ["Notion Calendar"] = ":calendar:",
    ["Caprine"] = ":caprine:",
    ["Citrix Workspace"] = ":citrix:",
    ["Citrix Viewer"] = ":citrix:",
    ["ClickUp"] = ":click_up:",
    ["Code"] = ":code:",
    ["Code - Insiders"] = ":code:",
    ["Color Picker"] = ":color_picker:",
    ["数码测色计"] = ":color_picker:",
    ["CotEditor"] = ":coteditor:",
    ["Cypress"] = ":cypress:",
    ["DataGrip"] = ":datagrip:",
    ["DataSpell"] = ":dataspell:",
    ["DaVinci Resolve"] = ":davinciresolve:",
    ["Default"] = ":default:",
    ["CleanMyMac X"] = ":desktop:",
    ["DEVONthink 3"] = ":devonthink3:",
    ["DingTalk"] = ":dingtalk:",
    ["钉钉"] = ":dingtalk:",
    ["阿里钉"] = ":dingtalk:",
    ["Discord"] = ":discord:",
    ["Discord Canary"] = ":discord:",
    ["Discord PTB"] = ":discord:",
    ["Docker"] = ":docker:",
    ["Docker Desktop"] = ":docker:",
    ["GrandTotal"] = ":dollar:",
    ["Receipts"] = ":dollar:",
    ["Double Commander"] = ":doublecmd:",
    ["Drafts"] = ":drafts:",
    ["Dropbox"] = ":dropbox:",
    ["Element"] = ":element:",
    ["Emacs"] = ":emacs:",
    ["Evernote Legacy"] = ":evernote_legacy:",
    ["FaceTime"] = ":face_time:",
    ["FaceTime 通话"] = ":face_time:",
    ["Figma"] = ":figma:",
    ["Final Cut Pro"] = ":final_cut_pro:",
    ["Finder"] = ":finder:",
    ["访达"] = ":finder:",
    ["Firefox"] = ":firefox:",
    ["Firefox Developer Edition"] = ":firefox_developer_edition:",
    ["Firefox Nightly"] = ":firefox_developer_edition:",
    ["Folx"] = ":folx:",
    ["Fusion"] = ":fusion:",
    ["System Preferences"] = ":gear:",
    ["System Settings"] = ":gear:",
    ["Systemeinstellungen"] = ":gear:",
    ["系统设置"] = ":gear:",
    ["Réglages Système"] = ":gear:",
    ["GitHub Desktop"] = ":git_hub:",
    ["Godot"] = ":godot:",
    ["GoLand"] = ":goland:",
    ["Chromium"] = ":google_chrome:",
    ["Google Chrome"] = ":google_chrome:",
    ["Google Chrome Canary"] = ":google_chrome:",
    ["Grammarly Editor"] = ":grammarly:",
    ["Home Assistant"] = ":home_assistant:",
    ["Hyper"] = ":hyper:",
    ["IntelliJ IDEA"] = ":idea:",
    ["Inkdrop"] = ":inkdrop:",
    ["Inkscape"] = ":inkscape:",
    ["Insomnia"] = ":insomnia:",
    ["Iris"] = ":iris:",
    ["iTerm"] = ":iterm:",
    ["iTerm2"] = ":iterm:",
    ["Jellyfin Media Player"] = ":jellyfin:",
    ["Joplin"] = ":joplin:",
    ["카카오톡"] = ":kakaotalk:",
    ["KakaoTalk"] = ":kakaotalk:",
    ["Kakoune"] = ":kakoune:",
    ["KeePassXC"] = ":kee_pass_x_c:",
    ["Secrets"] = ":one_password:",
    ["Keyboard Maestro"] = ":keyboard_maestro:",
    ["Keynote"] = ":keynote:",
    ["Keynote 讲演"] = ":keynote:",
    ["kitty"] = ":kitty:",
    ["League of Legends"] = ":league_of_legends:",
    ["LibreWolf"] = ":libre_wolf:",
    ["Adobe Lightroom"] = ":lightroom:",
    ["Lightroom Classic"] = ":lightroomclassic:",
    ["LINE"] = ":line:",
    ["Linear"] = ":linear:",
    ["LM Studio"] = ":lm_studio:",
    ["LocalSend"] = ":localsend:",
    ["Logic Pro"] = ":logicpro:",
    ["Logseq"] = ":logseq:",
    ["Canary Mail"] = ":mail:",
    ["HEY"] = ":mail:",
    ["Mail"] = ":mail:",
    ["Mailspring"] = ":mail:",
    ["MailMate"] = ":mail:",
    ["Superhuman"] = ":mail:",
    ["邮件"] = ":mail:",
    ["MAMP"] = ":mamp:",
    ["MAMP PRO"] = ":mamp:",
    ["Maps"] = ":maps:",
    ["Google Maps"] = ":maps:",
    ["Matlab"] = ":matlab:",
    ["Mattermost"] = ":mattermost:",
    ["Messages"] = ":messages:",
    ["信息"] = ":messages:",
    ["Nachrichten"] = ":messages:",
    ["Messenger"] = ":messenger:",
    ["Microsoft Edge"] = ":microsoft_edge:",
    ["Microsoft Excel"] = ":microsoft_excel:",
    ["Microsoft Outlook"] = ":microsoft_outlook:",
    ["Microsoft PowerPoint"] = ":microsoft_power_point:",
    ["Microsoft Remote Desktop"] = ":microsoft_remote_desktop:",
    ["Microsoft Teams"] = ":microsoft_teams:",
    ["Microsoft Teams (work or school)"] = ":microsoft_teams:",
    ["Microsoft Word"] = ":microsoft_word:",
    ["Min"] = ":min_browser:",
    ["Miro"] = ":miro:",
    ["MongoDB Compass"] = ":mongodb:",
    ["mpv"] = ":mpv:",
    ["Mullvad Browser"] = ":mullvad_browser:",
    ["Music"] = ":music:",
    ["音乐"] = ":music:",
    ["Musique"] = ":music:",
    ["Neovide"] = ":neovide:",
    ["neovide"] = ":neovide:",
    ["Neovim"] = ":neovim:",
    ["neovim"] = ":neovim:",
    ["nvim"] = ":neovim:",
    ["网易云音乐"] = ":netease_music:",
    ["Noodl"] = ":noodl:",
    ["Noodl Editor"] = ":noodl:",
    ["NordVPN"] = ":nord_vpn:",
    ["Notability"] = ":notability:",
    ["Notes"] = ":notes:",
    ["Notizen"] = ":notes:",
    ["备忘录"] = ":notes:",
    ["Notion"] = ":notion:",
    ["Nova"] = ":nova:",
    ["Numbers"] = ":numbers:",
    ["Numbers 表格"] = ":numbers:",
    ["Obsidian"] = ":obsidian:",
    ["OBS"] = ":obsstudio:",
    ["OmniFocus"] = ":omni_focus:",
    ["1Password"] = ":one_password:",
    ["ChatGPT"] = ":openai:",
    ["OpenVPN Connect"] = ":openvpn_connect:",
    ["Opera"] = ":opera:",
    ["OrcaSlicer"] = ":orcaslicer:",
    ["Orion"] = ":orion:",
    ["Orion RC"] = ":orion:",
    ["Pages"] = ":pages:",
    ["Pages 文稿"] = ":pages:",
    ["Parallels Desktop"] = ":parallels:",
    ["Parsec"] = ":parsec:",
    ["Pearcleaner"] = ":desktop:",
    ["Preview"] = ":pdf:",
    ["预览"] = ":pdf:",
    ["Skim"] = ":pdf:",
    ["zathura"] = ":pdf:",
    ["Aperçu"] = ":pdf:",
    ["PDF Expert"] = ":pdf_expert:",
    ["Adobe Photoshop"] = ":photoshop:",
    ["Pi-hole Remote"] = ":pihole:",
    ["Pine"] = ":pine:",
    ["Podcasts"] = ":podcasts:",
    ["播客"] = ":podcasts:",
    ["PomoDone App"] = ":pomodone:",
    ["Postman"] = ":postman:",
    ["PrusaSlicer"] = ":prusaslicer:",
    ["SuperSlicer"] = ":prusaslicer:",
    ["PyCharm"] = ":pycharm:",
    ["QQ"] = ":qq:",
    ["QQ音乐"] = ":qqmusic:",
    ["QQMusic"] = ":qqmusic:",
    ["Quantumult X"] = ":quantumult_x:",
    ["qutebrowser"] = ":qute_browser:",
    ["Raindrop.io"] = ":raindrop_io:",
    ["Reeder"] = ":reeder5:",
    ["Reminders"] = ":reminders:",
    ["提醒事项"] = ":reminders:",
    ["Rappels"] = ":reminders:",
    ["Replit"] = ":replit:",
    ["Rider"] = ":rider:",
    ["JetBrains Rider"] = ":rider:",
    ["Safari"] = ":safari:",
    ["Safari浏览器"] = ":safari:",
    ["Safari Technology Preview"] = ":safari:",
    ["Sequel Ace"] = ":sequel_ace:",
    ["Sequel Pro"] = ":sequel_pro:",
    ["Setapp"] = ":setapp:",
    ["SF Symbols"] = ":sf_symbols:",
    ["Signal"] = ":signal:",
    ["Sketch"] = ":sketch:",
    ["Skype"] = ":skype:",
    ["Slack"] = ":slack:",
    ["Spark"] = ":spark:",
    ["Spotify"] = ":spotify:",
    ["Spotlight"] = ":spotlight:",
    ["Sublime Text"] = ":sublime_text:",
    ["Tana"] = ":tana:",
    ["TeamSpeak 3"] = ":team_speak:",
    ["Telegram"] = ":telegram:",
    ["Terminal"] = ":terminal:",
    ["终端"] = ":terminal:",
    ["Typora"] = ":text:",
    ["Microsoft To Do"] = ":things:",
    ["Things"] = ":things:",
    ["Thunderbird"] = ":thunderbird:",
    ["Thunderbird Beta"] = ":thunderbird:",
    ["TickTick"] = ":tick_tick:",
    ["TIDAL"] = ":tidal:",
    ["Tiny RDM"] = ":tinyrdm:",
    ["Todoist"] = ":todoist:",
    ["Toggl Track"] = ":toggl_track:",
    ["Tor Browser"] = ":tor_browser:",
    ["Tower"] = ":tower:",
    ["Transmit"] = ":transmit:",
    ["Trello"] = ":trello:",
    ["Tweetbot"] = ":twitter:",
    ["Twitter"] = ":twitter:",
    ["MacVim"] = ":vim:",
    ["Vim"] = ":vim:",
    ["VimR"] = ":vim:",
    ["Vivaldi"] = ":vivaldi:",
    ["VLC"] = ":vlc:",
    ["VMware Fusion"] = ":vmware_fusion:",
    ["VSCodium"] = ":vscodium:",
    ["Warp"] = ":warp:",
    ["WebStorm"] = ":web_storm:",
    ["微信"] = ":wechat:",
    ["WeChat"] = ":wechat:",
    ["企业微信"] = ":wecom:",
    ["WeCom"] = ":wecom:",
    ["WezTerm"] = ":wezterm:",
    ["WhatsApp"] = ":whats_app:",
    ["‎WhatsApp"] = ":whats_app:",
    ["Xcode"] = ":xcode:",
    ["Яндекс Музыка"] = ":yandex_music:",
    ["Yuque"] = ":yuque:",
    ["语雀"] = ":yuque:",
    ["Zed"] = ":zed:",
    ["Zeplin"] = ":zeplin:",
    ["Zen Browser"] = ":firefox:",
    ["zoom.us"] = ":zoom:",
    ["Zotero"] = ":zotero:",
    ["Zulip"] = ":zulip:",
    ["default"] = ":default:",
  }
  
  local text <const> = {
    nerdfont = {
      plus = "",
      loading = "",
      apple = "",
      gear = "",
      cpu = "",
      clipboard = "󰅇",
      switch = {
        on = "󱨥",
        off = "󱨦",
      },
      volume = {
        _100 = "",
        _66 = "",
        _33 = "",
        _10 = "",
        _0 = "",
      },
      battery = {
        _100 = "",
        _75 = "",
        _50 = "",
        _25 = "",
        _0 = "",
        charging = "",
      },
      wifi = {
        upload = "",
        download = "",
        connected = "󰖩",
        disconnected = "󰖪",
        router = "󰑩",
      },
      media = {
        back = "",
        forward = "",
        play_pause = "",
      },
      slider = {
        knob = ""
      }
    },
  }
  
  return {
    text = text.nerdfont,
    apps = apps,
  }