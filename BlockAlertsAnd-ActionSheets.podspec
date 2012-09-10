Pod::Spec.new do |s|
  s.name         = "BlockAlertsAnd-ActionSheets"
  s.version      = "0.0.1"
  s.summary      = "Fork of Arrived's BlockAlertsAndActionSheets to add rotation support, a text prompt alert, and a table select alert."
  s.homepage     = "https://github.com/barrettj/BlockAlertsAnd-ActionSheets"
  s.license      = 'MIT'
  s.author       = { "Barrett Jacobsen" => "admin@barretj.com" }
  s.source       = { :git => "https://github.com/barrettj/BlockAlertsAnd-ActionSheets.git" }
  s.platform     = :ios, '4.3'
  s.source_files =  "BlockAlertsDemo/BlockActionSheet.{h,m}", "BlockAlertsDemo/BlockAlertView.{h,m}", "BlockAlertsDemo/BlockBackground.{h,m}", "BlockAlertsDemo/BlockTableAlertView.{h,m}", "BlockAlertsDemo/BlockTextPromptAlertView.{h,m}"
  s.resources = "BlockAlertsDemo/images/*.png"
end
