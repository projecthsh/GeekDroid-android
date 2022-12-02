
function dataInput(str,file,para)
  activity.getSharedPreferences(file,Context.MODE_PRIVATE)
  .edit()
  .putString(para,str)
  .commit()
end

function dataRead(file)
  sp = activity.getSharedPreferences(file,Context.MODE_PRIVATE)
end

function dataNegate(file,para)
  --dataRead(file)
  if sp.getString(para,"")=="关闭" then
    dataInput("开启",file,para)
   else
    dataInput("关闭",file,para)
  end
end


dataRead("settings")
--初始化设置数据
setList={"MYswitch","autoInstall"}
for index,content in pairs(setList) do
  local c=sp.getString(content,nil)
  if c==nil then
    dataInput("关闭","settings",content)
  end
end
