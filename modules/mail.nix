{
  flake.modules.homeManager.mail = {
    programs.thunderbird = {
      enable = true;
      profiles.default.isDefault = true;
      settings = {
        "mailnews.database.global.indexer.enabled" = false;
        "mail.server.default.offline_download" = false;
        "mailnews.start_page.enabled" = false;
        "mail.shell.checkDefaultClient" = false;
        "mail.chat.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.enabled" = false;
      };
    };
  };
}
