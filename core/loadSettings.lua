--设置初始JSON地址
if sp.getString("JSON","")=="" then
  dataInput("https://raw.githubusercontent.com/projecthsh/Project-HSH/master/index-1.json","settings","JSON")
  url_json="https://raw.githubusercontent.com/projecthsh/Project-HSH/master/index-1.json"
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

if sp.getString("suInstall",nil)=="开启" then
  suSwitch.setChecked(true)
end


--设置初始启动弹窗
if sp.getString("isFirstStart","")=="" then
  local packinfo = this.getPackageManager().getPackageInfo(this.getPackageName(), 64.0)
  local FirstStartLayout=
  {
    LinearLayoutCompat,
    orientation="vertical",
    padding="12dp",
    {
      MaterialTextView,
      text="GeekDroid的运行需要授予存储权限，稍后将自动申请权限",
      textColor=primaryc,
      Typeface=Typeface.defaultFromStyle(Typeface.BOLD);
    },
    {
      NestedScrollView,
      layout_width="match_parent";
      layout_height="30%h";
      {
        MaterialTextView,
        layout_marginTop="10dp",
        text=getPrivatePrivacy(),
      },
    },
  }
  MaterialAlertDialogBuilder(this)
  .setTitle("GeekDroid_"..tostring(packinfo.versionName))
  .setView(loadlayout(FirstStartLayout))
  .setPositiveButton("我已阅读协议",function()
    dataInput("true","settings","isFirstStart")
    --申请权限
    function requestPermissions(permissions)
      local ActivityCompat = luajava.bindClass "androidx.core.app.ActivityCompat"
      return ActivityCompat.requestPermissions(activity, permissions, 10);
    end
    --申请权限的回调在这里执行
    onRequestPermissionsResult=function(requestCode, permissions, grantResults)
      local PackageManager = luajava.bindClass "android.content.pm.PackageManager"
      --判断是不是自己的权限申请，这里的10就是上面requestPermissions中写的10
      if requestCode==10 then
        local count = 0
        for i=0,#permissions-1 do
          if grantResults[i] == PackageManager.PERMISSION_GRANTED then
            --print(permissions[i].."权限通过")
            count = count + 1
           else
            --print(permissions[i].."权限拒绝")
          end
        end
        --print("申请了"..#permissions.."个权限，通过了"..count.."个权限")
      end
    end
    --要申请的权限列表
    --所有的权限常量定义在Manifest的内部类permission里，写法如下
    local Manifest = luajava.bindClass "android.Manifest"
    --以储存权限为例
    local requirePermissions =
    {
      Manifest.permission.READ_EXTERNAL_STORAGE,
      Manifest.permission.WRITE_EXTERNAL_STORAGE
    }
    requestPermissions(requirePermissions)
  end)
  .setNegativeButton("退出",function()
    activity.finish()
  end)
  .setCancelable(false)
  .show()
end