--动态申请所有权限
function ApplicationAuthority()
  local mAppPermissions = ArrayList()
  local mAppPermissionsTable = luajava.astable(activity.getPackageManager().getPackageInfo(activity.getPackageName(),PackageManager.GET_PERMISSIONS).requestedPermissions)
  for k,v in pairs(mAppPermissionsTable) do
    mAppPermissions.add(v)
  end
  local size = mAppPermissions.size()
  local mArray = mAppPermissions.toArray(String[size])
  activity.requestPermissions(mArray,0)
end
--ApplicationAuthority()
--[[权限申请回调
        onRequestPermissionsResult=function(r,p,g)
        end]]


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

Manifest = luajava.bindClass "android.Manifest"

if Build.VERSION.SDK_INT >= 31 then
  requirePermissions =
  {
    Manifest.permission.MANAGE_EXTERNAL_STORAGE
  }
 else
  requirePermissions =
  {
    Manifest.permission.READ_EXTERNAL_STORAGE,
    Manifest.permission.WRITE_EXTERNAL_STORAGE
  }
end
--检查权限
function checkPermission(permission)
  return 0==activity.checkSelfPermission(permission)
end