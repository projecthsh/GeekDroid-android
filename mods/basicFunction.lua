import{
  "android.content.Context",
  "android.content.pm.PackageManager",
}
function 静默安装(路径,文件)
  io.popen("su -c 'cp -rf "..路径.." /data/local/tmp/"..文件..".apk".."'")
  io.popen("su -c 'pm install ".."/data/local/tmp/"..文件 ..".apk".."'")
end
--静默安装("/storage/emulated/0/base.apk","名称")

function exec(cmd,sh,su)
  cmd=tostring(cmd)
  if sh == true then
    cmd=io.open(cmd):read("*a")
  end
  if su == 0 then
    p=io.popen(string.format('%s',cmd))
   else
    p=io.popen(string.format('%s',"su -c "..cmd))
  end
  local s=p:read("*a")
  p:close()
  return s
end

function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end

function print(content)
  Snackbar.make(vpg,content,Snackbar.LENGTH_SHORT).setAnchorView(bottombar).show();
end

--初始化ripple
rippleRes = TypedValue()
activity.getTheme().resolveAttribute(android.R.attr.selectableItemBackground, rippleRes, true)

function getFileDrawable(file)
  fis = FileInputStream(activity.getLuaDir().."/res/"..file..".png")
  bitmap = BitmapFactory.decodeStream(fis)
  return BitmapDrawable(activity.getResources(), bitmap)
end

--隐藏输入法
function hideInput(inputid)
  import "android.view.inputmethod.InputMethodManager"
  activity.getSystemService(Context.INPUT_METHOD_SERVICE).hideSoftInputFromWindow(inputid.getWindowToken(),0)
end

