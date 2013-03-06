Pod::Spec.new do |spec|
  spec.name     = 'BlockAlertsAnd-ActionSheets'
  spec.version  = '1.0.0'
  spec.license  = 'MIT'
  spec.summary  = 'Beautifully done UIAlertView and UIActionSheet replacements inspired by TweetBot.'
  spec.homepage = 'https://github.com/gpambrozio/BlockAlertsAnd-ActionSheets'
  spec.author   = { 'Gustavo Ambrozio' => '' }
  spec.source   = { :git => 'https://github.com/MacMannes/BlockAlertsAnd-ActionSheets.git' }
  spec.description = 'Beautifully done UIAlertView and UIActionSheet replacements inspired by TweetBot.'
  spec.platform = :ios
  spec.source_files = 'BlockAlertsDemo/ToAddToYourProjects', 'BlockAlertsDemo/ProjectSpecific/BlockUI.h'
  spec.resources = "BlockAlertsDemo/images/ActionSheet/*.png", "BlockAlertsDemo/images/AlertView/*.png"
  spec.requires_arc = true
end
