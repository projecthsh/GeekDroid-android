--设置主题
activity.setTheme(R.style.Theme_ReOpenLua_Material3)
if sp.getString("MYswitch",nil)=="开启" then
  import"com.google.android.material.color.DynamicColors"
  DynamicColors.applyIfAvailable(this)
end

--初始化颜色
--为了使深色主题效果正常，请不要使用硬编码颜色!
local themeUtil=LuaThemeUtil(this)
MDC_R=luajava.bindClass"com.google.android.material.R"
surfaceColor=themeUtil.getColorSurface()
backgroundc=themeUtil.getColorBackground()
surfaceVar=themeUtil.getColorSurfaceVariant()
onsurfaceVar=themeUtil.getColorOnSurfaceVariant()
titleColor=themeUtil.getTitleTextColor()
textc=themeUtil.getTextColor()
titletextc=themeUtil.getTitleTextColor()
menuc=themeUtil.getActionMenuTextColor()
primaryc=themeUtil.getColorPrimary()
primarycVar=themeUtil.getColorPrimaryVariant()
secondaryc=themeUtil.getColorSecondary()
onsecondaryc=themeUtil.getColorOnSecondary()
tertiaryc=themeUtil.getColorTertiary()
ontertiaryc=themeUtil.getColorOnTertiary()
tertiaryContain=themeUtil.getColorTertiaryContainer()

function createColorStateList(normal,pressed,focused,unable)
  local colors = { pressed, focused, normal, focused, unable, normal };
  local states={}
  states[0] ={ android.R.attr.state_pressed, android.R.attr.state_enabled };
  states[1] ={ android.R.attr.state_enabled, android.R.attr.state_focused };
  states[2] ={ android.R.attr.state_enabled };
  states[3] ={ android.R.attr.state_focused };
  states[4] ={ android.R.attr.state_window_focused };
  states[5] ={};
  colorList = ColorStateList(states, colors);
  return colorList
end