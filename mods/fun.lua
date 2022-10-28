import{
  "android.content.Context",
}
function 自动安装(路径,文件)
  io.popen("su -c 'cp -rf "..路径.." /data/local/tmp/"..文件..".apk".."'")
  io.popen("su -c 'pm install ".."/data/local/tmp/"..文件 ..".apk".."'")
end
--自动安装("/storage/emulated/0/base.apk","名称")

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
  Toast.makeText(activity,content, Toast.LENGTH_SHORT).show()
end

