--设置主题
--[[do
  local _ENV={activity=this,style=luajava.bindClass'com.google.android.material.R$style'}
  activity.theme=style.Theme_Material3_DayNight
end]]
activity.setTheme(R.style.Theme_ReOpenLua_Material3)
if sp.getString("MYswitch",nil)=="开启" then
  import"com.google.android.material.color.DynamicColors"
  DynamicColors.applyIfAvailable(this)
end

--初始化颜色
local themeUtil=LuaThemeUtil(this)
MDC_R=luajava.bindClass"com.google.android.material.R"
surfaceColor=themeUtil.getColorSurface()
surfaceVar=themeUtil.getColorSurfaceVariant()
onsurfaceVar=themeUtil.getColorOnSurfaceVariant()
onsurfaceInv=themeUtil.getColorOnSurfaceInverse()
backgroundc=themeUtil.getColorBackground()
onbackgroundColor=themeUtil.getColorOnBackground()
titleColor=themeUtil.getTitleTextColor()
textColor=themeUtil.getTextColor()
menuColor=themeUtil.getActionMenuTextColor()
primaryColor=themeUtil.getColorPrimary()
primaryVar=themeUtil.getColorPrimaryVariant()
secondaryColor=themeUtil.getColorSecondary()
onSecondaryColor=themeUtil.getColorOnSecondary()
tertiaryc=themeUtil.getColorTertiary()
ontertiaryc=themeUtil.getColorOnTertiary()
tertiaryContain=themeUtil.getColorTertiaryContainer()
ontertiaryContain=themeUtil.getColorOnTertiaryContainer()

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