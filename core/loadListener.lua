
function onClickFab()
end

function onClickClear(v)
  tLink.setText("")
  tPackage.setText("")
  tDesc.setText("")
  tVer.setText("")
  tName.setText("")
  tLogo.setText("")
  tSize.setText("")
end

function onClickGenerate()
  local dataTable={}
  dataTable["type"]="apk"
  dataTable["link"]=tLink.Text
  dataTable["package"]=tPackage.Text
  dataTable["desc"]=tDesc.Text
  dataTable["ver"]=tVer.Text
  dataTable["name"]=tName.Text
  dataTable["logo"]=tLogo.Text
  dataTable["size"]=tSize.Text
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(cjson.encode(dataTable))
end

monetSwitch.setOnCheckedChangeListener{
  onCheckedChanged=function()
    dataNegate("settings","MYswitch")
    snack("切换后需要重启应用以生效")
  end
}

autoSwitch.setOnCheckedChangeListener{
  onCheckedChanged=function()
    dataNegate("settings","autoInstall")
  end
}

suSwitch.setOnCheckedChangeListener{
  onCheckedChanged=function()
    local RootUtil=luajava.bindClass"com.androlua.util.RootUtil"
    if RootUtil.haveRoot() then
      dataNegate("settings","suInstall")
     else
      suSwitch.setChecked(false)
    end
  end
}
