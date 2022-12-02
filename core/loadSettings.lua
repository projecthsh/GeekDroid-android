--设置初始JSON地址
if sp.getString("JSON","")=="" then
  dataInput("https://raw.githubusercontent.com/znzsofficial/Project-HSH/master/index-1.json","settings","JSON")
  url_json="https://raw.githubusercontent.com/znzsofficial/Project-HSH/master/index-1.json"
 else
  url_json=sp.getString("JSON",nil)
end

--设置初始下载地址
if sp.getString("FileAddress","")=="" then
  dataInput("/sdcard/Download/","settings","FileAddress")
  SelectDownload.getChildAt(0).getChildAt(1).setText("当前下载路径"..sp.getString("FileAddress",""))
end

--设置部分
if sp.getString("MYswitch",nil)=="开启" then
  Materialswitch.setChecked(true)
end

if sp.getString("autoInstall",nil)=="开启" then
  autoSwitch.setChecked(true)
end
