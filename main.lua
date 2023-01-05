require "import"
import {
  "android.os.*",
  "android.widget.*",
  "android.view.*",
  "android.animation.LayoutTransition",
  "android.content.Intent",
  "android.content.res.ColorStateList",
  "android.graphics.BitmapFactory",
  "android.graphics.PorterDuff",
  "android.graphics.drawable.GradientDrawable$Orientation",
  "android.graphics.drawable.Drawable",
  "android.graphics.drawable.BitmapDrawable",
  "android.graphics.drawable.ColorDrawable",
  "android.graphics.Typeface",
  "android.util.TypedValue",
  "android.net.Uri",
  "java.io.FileInputStream",
  "java.util.concurrent.TimeUnit",

  "androidx.appcompat.widget.LinearLayoutCompat",
  "androidx.appcompat.widget.AppCompatImageView",
  "androidx.core.widget.NestedScrollView",
  "androidx.coordinatorlayout.widget.CoordinatorLayout",
  "androidx.recyclerview.widget.RecyclerView",
  "androidx.recyclerview.widget.LinearLayoutManager",

  "com.google.android.material.appbar.AppBarLayout",
  "com.google.android.material.appbar.MaterialToolbar",
  "com.google.android.material.button.MaterialButton",
  "com.google.android.material.bottomnavigation.BottomNavigationView",
  "com.google.android.material.button.MaterialButtonToggleGroup",
  "com.google.android.material.card.MaterialCardView",
  "com.google.android.material.dialog.MaterialAlertDialogBuilder",
  "com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton",
  "com.google.android.material.materialswitch.MaterialSwitch",
  "com.google.android.material.radiobutton.MaterialRadioButton",
  "com.google.android.material.snackbar.Snackbar",
  "com.google.android.material.tabs.TabLayout",
  "com.google.android.material.textview.MaterialTextView",
  "com.google.android.material.textfield.TextInputEditText",
  "com.google.android.material.textfield.TextInputLayout",

  "github.daisukiKaffuChino.AdapterCreator",
  "github.daisukiKaffuChino.CustomViewPager",
  "github.daisukiKaffuChino.LuaCustRecyclerAdapter",
  "github.daisukiKaffuChino.LuaCustRecyclerHolder",
  "github.daisukiKaffuChino.utils.LuaThemeUtil",

  "com.daimajia.androidanimations.library.Techniques",
  "com.daimajia.androidanimations.library.YoYo",
  "com.bumptech.glide.Glide",
  "com.bumptech.glide.request.RequestOptions",
  "com.bumptech.glide.load.engine.DiskCacheStrategy",

  "mods.Permission",
  "mods.basicFunction",
  "mods.settingFunction",
  "mods.CustomPopupWindow",
  "mods.PrivacyDocument",

  "core.loadColor",
  "core.loadmLayout",
  "core.loadSettings",
  "core.loadListener",
  "core.loadDialog",
}

--导入okhttp
local OkHttpClient,OkHttpRequest,OkHttpCallback=luajava.bindClass"okhttp3.OkHttpClient",luajava.bindClass"okhttp3.Request",luajava.bindClass"okhttp3.Callback"
--导入cjson
cjson=require "cjson"
--导入rawio by旋律
rawio=require "rawio"

--顶栏菜单点击监听
import "androidx.appcompat.widget.Toolbar$OnMenuItemClickListener"
toolbar.setOnMenuItemClickListener(OnMenuItemClickListener{
  onMenuItemClick=function(item)
  switch item.getItemId() do
     case 0
      --换源Dialog
      --设置布局表
      local SelectLayout=
      {
        LinearLayoutCompat,
        orientation="vertical",
        orientation="vertical",
        layout_width="match_parent";
        padding="20dp";
        {
          TextInputEditText;
          layout_width="match_parent";
          layout_gravity="center",
          tooltipText="输入你的JSON源",
          hint="自定义JSON源";
          id="jsonEdit";
        },
        {
          MaterialTextView,
          layout_marginTop="10dp",
          textSize="10sp",
          tooltipText=url_json,
          text="当前地址:\n"..url_json,
          Typeface=Typeface.defaultFromStyle(Typeface.BOLD);
          onClick=function()
            activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(tostring(url_json))
          end,
        },
      }

      local items={"默认","Dev","自定义"}
      if url_json=="https://phsh.bangumi.cyou/index-1.json" then
        selectIndex=0 --选中项索引
       elseif url_json=="https://raw.githubusercontent.com/znzsofficial/Project-HSH/master/index-1.json"
        selectIndex=1
       else
        selectIndex=2
      end

      local json_dialog=MaterialAlertDialogBuilder(this)
      .setTitle("更换JSON源")
      .setSingleChoiceItems(items,selectIndex,{
        onClick=function(json_dialog,i)

          if tonumber(i)==0 then
            dataInput("https://phsh.bangumi.cyou/index-1.json","settings","JSON")
           elseif tonumber(i)==1 then
            dataInput("https://raw.githubusercontent.com/znzsofficial/Project-HSH/master/index-1.json","settings","JSON")
           else
          end

          --重新设置url_json
          resetJson()

        end
      })
      .setView(loadlayout(SelectLayout))
      .setPositiveButton("刷新",function()
        --隐藏输入法
        hideInput(jsonEdit)
        --清空Table
        superTable={}
        --刷新适配器
        adapterm.notifyDataSetChanged()
        --显示加载提示
        mainProgress.setVisibility(0)
        optionText.setVisibility(0)
        optionText.setText("加载中...")
        --okhttp请求
        pcall(function()
          --请求辅助类
          local mRequest = OkHttpRequest.Builder()
          .url(url_json)
          .build();
          --异步请求
          OkHttpClient.Builder()
          .retryOnConnectionFailure(true)
          .readTimeout(30,TimeUnit.SECONDS)
          .writeTimeout(30,TimeUnit.SECONDS)
          .connectTimeout(30,TimeUnit.SECONDS);

          local mClient = OkHttpClient()
          local mCall = mClient.newCall(mRequest)
          mCall.enqueue(OkHttpCallback{
            onFailure=function(call,e)
              mSetText(optionText,"连接失败，请检查你的网络设置或JSON源")
            end,
            onResponse=function(call,response)
              mLoadTable(response.body().string())
          end})
        end)

      end)
      .show()
      --EditText监听
      jsonEdit.addTextChangedListener{
        onTextChanged=function()
          dataInput(tostring(jsonEdit.getText()),"settings","JSON")
          --重新设置url_json
          resetJson()
        end
      }

     case 1
      --退出应用
      activity.finish()
    end
  end
})

--主RecyclerAdapter部分
local Mitem=
{LinearLayoutCompat,
  Orientation=0,
  layout_width="fill",
  layout_height="wrap",
  paddingTop='16dp';
  paddingLeft='16dp';
  paddingRight='16dp';
  {
    MaterialCardView,
    radius="16dp",
    layout_width='fill';
    layout_height='wrap';
    strokeWidth="0dp",
    layout_margin="6dp",
    {LinearLayoutCompat,
      Orientation=0,
      layout_width="fill",
      layout_height="wrap",
      id="contents",
      {AppCompatImageView,
        layout_marginTop="16dp",
        layout_marginBottom="16dp",
        layout_marginLeft="8dp",
        layout_width="42dp",
        layout_height="42dp",
        id="icon",
      },
      {LinearLayoutCompat,
        layout_width="fill",
        layout_height="wrap",
        layout_marginTop="4dp",
        layout_marginBottom="4dp",
        layout_marginLeft="16dp",
        Orientation=1,
        {MaterialTextView,
          textSize="18sp",
          id="title",
        },
        {MaterialTextView,
          textSize="13sp",
          id="profile",
        },
        {MaterialTextView,
          textSize="13sp",
          id="pack",
        },
      },
    },
  },
};
--设置空Table
superTable={}
--设置主RV适配器
adapterm=LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #superTable
  end,
  getItemViewType=function(position)
    return superTable[position+1].type
  end,
  onCreateViewHolder=function(parent,viewType)
    local views={}
    holder=LuaCustRecyclerHolder(loadlayout(Mitem,views))
    holder.view.setTag(views)
    return holder
  end,
  onBindViewHolder=function(holder,position)
    view=holder.view.getTag()
    local app=superTable[position+1]
    view.title.Text=app.name
    view.profile.Text=app.desc
    view.pack.Text=app.package
    --Glide配置
    local options = RequestOptions()
    .placeholder(getFileDrawable("preload"))
    .diskCacheStrategy(DiskCacheStrategy.AUTOMATIC);
    Glide.with(activity).asDrawable().load(app.logo).apply(options).into(view.icon)

    view.contents.backgroundResource=rippleRes.resourceId
    view.contents.onClick=function(v)
      --点击显示PopupWindow
      local popMenu={
        ["下载"]=function()
          --检查下载链接
          if app.link=="" or app.link==nil then
            print(app.name.."暂无下载链接")
           else
            --检查是否有正在下载的任务
            if isDownloading==true then
              --当前下载任务是否为选择的App
              if nowDownloading~=app.name then
                print(nowDownloading.."下载任务正在进行")
                return true
               else
                CustomDownloader()
              end
             else
              CustomDownloader()
            end
          end
        end,
        ["详情"]={
          ["暂无"]=function()
          end,
        },
      }
      showPopMenu(popMenu,v,app.name)
      --下载器
      function CustomDownloader(v)
        --存储权限检查
        local flag = checkPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)
        if flag== false then
          requestPermissions(requirePermissions)
          print("请授予存储权限后尝试下载")
          return true
        end
        flag=nil--回收变量
        isDialogCanceled=nil
        --设置布局表
        local downloadLayout=
        {
          LinearLayoutCompat,
          orientation='vertical',
          layout_width='fill',
          layout_height='wrap',
          padding="10dp",
          {
            LinearLayoutCompat,
            orientation='horizontal',
            gravity='center|left';
            layout_width='fill',
            layout_height='fill',
            {
              LinearLayoutCompat,
              orientation='vertical',
              layout_width='fill',
              layout_weight='1';
              layout_marginLeft='10dp';
              gravity='center|left';
              {
                MaterialTextView;
                Typeface=Typeface.defaultFromStyle(Typeface.BOLD);
                textSize='12dp';
                id="TipDown";
              };
            };
          };
          {
            ProgressBar;
            layout_width='fill';
            layout_marginLeft='16dp';
            layout_marginRight='16dp';
            id="progress_down",
            style='?android:attr/progressBarStyleHorizontal';
          };
          {
            LinearLayoutCompat,
            orientation='horizontal',
            layout_width='fill',
            layout_height='wrap',
            gravity="center",
            padding="10dp",
            {
              MaterialButtonToggleGroup,
              id="btnGroup",
              layout_width="wrap",
              layout_height="wrap",
              layout_gravity="center",
              singleSelection=true,
              SelectionRequired=true,
              {
                MaterialButton;
                gravity='center';
                text='隐藏';
                textSize='12dp';
                id="cancel_down",
              };
              {
                MaterialButton;
                gravity='center';
                text='复制链接';
                textSize='12dp';
                id="copy_down",
              };
              {
                MaterialButton;
                gravity='center';
                text='下载';
                textSize='12dp';
                id="start_down",
              };
            },
          },
        };


        download_Dialog=MaterialAlertDialogBuilder(this)
        .setTitle(app.name.."下载")
        .setView(loadlayout(downloadLayout))
        .show()
        --用于下载进程内的Toast
        function makeFinshToast()
          Toast.makeText(activity, "静默安装时请勿退出GeekDroid",Toast.LENGTH_SHORT).show()
        end

        function trans(url,path,appname)
          require "import"
          import "java.net.URL"
          local ur =URL(url)
          import "java.io.File"
          file =File(path);
          con = ur.openConnection();
          co = con.getContentLength();
          is = con.getInputStream();
          bs = byte[1024]
          local len,read=0,0
          import "java.io.FileOutputStream"
          wj= FileOutputStream(path);
          len = is.read(bs)
          while len~=-1 do
            wj.write(bs, 0, len);
            read=read+len
            pcall(call,"download_ing",read,co)
            len = is.read(bs)
          end
          wj.close();
          is.close();
          pcall(call,"download_stop",co)
          import "android.content.Context"
          --获取下载设置
          sp = activity.getSharedPreferences("settings",Context.MODE_PRIVATE)
          if sp.getString("autoInstall",nil)=="开启" then
            if sp.getString("suInstall",nil)=="开启" then
              call("makeFinshToast")
              io.popen("su -c 'cp -rf "..path.." /data/local/tmp/"..appname..".apk".."'")
              io.popen("su -c 'pm install ".."/data/local/tmp/"..appname..".apk".."'")
             else
              activity.installApk(path)
            end
           else
          end
        end
        function download(url,path,appname)
          thread(trans,url,path,appname)
        end

        cancel_down.onClick=function()
          --如果正在下载则设置对话框隐藏状态
          if isDownloading==true then
            isDialogCanceled=true
          end
          download_Dialog.cancel()
        end

        copy_down.onClick=function()
          activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(app.link)
        end

        start_down.onClick=function()

          function mResponse()
            Thread(Runnable{
              run = function()
                this.runOnUiThread(Runnable{
                  run = function()
                    TipDown.Text="下载进程正在启动中..."
                    sp = activity.getSharedPreferences("settings",Context.MODE_PRIVATE)
                    filePath=sp.getString("FileAddress",nil)..app.name..".apk"
                    import "java.io.File"
                    File(sp.getString("FileAddress",nil)).mkdirs()
                    download(app.link,filePath,app.name)
                    progress_down.setVisibility(0)
                end})
            end}).start()
          end

          function mError()
            Thread(Runnable{
              run = function()
                this.runOnUiThread(Runnable{
                  run = function()
                    start_down.Text="下载"
                    TipDown.Text="连接失败，请检查你的网络设置"
                end})
            end}).start()
          end

          if start_down.Text=="下载" then
            start_down.Text="..."
            TipDown.Text="正在检查网络连接..."

            --导入okhttp
            local OkHttpClient,OkHttpRequest,OkHttpCallback=luajava.bindClass"okhttp3.OkHttpClient",luajava.bindClass"okhttp3.Request",luajava.bindClass"okhttp3.Callback"
            pcall(function()
              --请求辅助类
              local request = OkHttpRequest.Builder()
              .url(url_json)
              .build();
              --异步请求
              local client = OkHttpClient()
              local callz = client.newCall(request)
              callz.enqueue(OkHttpCallback{
                onFailure=function(call,e)
                  mError()
                end,
                onResponse=function(call,response)
                  mResponse()
              end})
            end)
           elseif start_down.Text=="安装" then
            --按设置方式安装
            if sp.getString("suInstall",nil)=="开启" then
              Toast.makeText(activity, "静默安装时请勿退出GeekDroid",Toast.LENGTH_SHORT).show()
              io.popen("su -c 'cp -rf "..filePath.." /data/local/tmp/"..app.name..".apk".."'")
              io.popen("su -c 'pm install ".."/data/local/tmp/"..app.name..".apk".."'")
             else
              activity.installApk(filePath)
            end
           else
          end
        end

        function download_ing(a,b)--已下载，总长度(byte)
          isDownloading=true
          nowDownloading=app.name
          TipDown.Text="正在下载："..string.format("%0.2f",a/1024/1024).."MB/"..string.format("%0.2f",b/1024/1024).."MB"
          progress_down.progress=(a/b*100)
          start_down.Text=string.format('%.2f',(a/b*100)).."%"
        end

        --下载完成后调用
        function download_stop(c)--总长度
          isDownloading=false
          nowDownloading=nil
          cancel_down.setVisibility(8)
          start_down.Text="安装"
          TipDown.Text="下载完成："..string.format("%0.2f",c/1024/1024).."MB"
          if isDialogCanceled==true then
            local _s=Snackbar.make(vpg,app.name.."下载完成",Snackbar.LENGTH_SHORT)
            .setAction("安装", View.OnClickListener{
              onClick=function()
                if sp.getString("suInstall",nil)=="开启" then
                  Toast.makeText(activity, "静默安装时请勿退出GeekDroid",Toast.LENGTH_SHORT).show()
                  io.popen("su -c 'cp -rf "..filePath.." /data/local/tmp/"..app.name..".apk".."'")
                  io.popen("su -c 'pm install ".."/data/local/tmp/"..app.name..".apk".."'")
                 else
                  activity.installApk(filePath)
                end
              end
            }).show();
            if vpg.getCurrentItem() ==1 then
              _s.setAnchorView(fab)
             else
              _s.setAnchorView(bottombar)
            end

          end
        end
      end
    end
  end,
}))
recycler_view.setAdapter(adapterm)
recycler_view.setLayoutManager(LinearLayoutManager(this))
local OverScrollDecoratorHelper=luajava.bindClass("me.everything.android.ui.overscroll.OverScrollDecoratorHelper")
OverScrollDecoratorHelper.setUpOverScroll(recycler_view, OverScrollDecoratorHelper.ORIENTATION_VERTICAL)

pcall(function()
  --请求辅助类
  local mRequest = OkHttpRequest.Builder()
  .url(url_json)
  .build();
  --异步请求
  OkHttpClient.Builder()
  .retryOnConnectionFailure(true)
  .readTimeout(30,TimeUnit.SECONDS)
  .writeTimeout(30,TimeUnit.SECONDS)
  .connectTimeout(30,TimeUnit.SECONDS);

  local mClient = OkHttpClient()
  local mCall = mClient.newCall(mRequest)
  mCall.enqueue(OkHttpCallback{
    onFailure=function(call,e)
      mSetText(optionText,"连接失败，请检查你的网络设置或JSON源")
    end,
    onResponse=function(call,response)
      mLoadTable(response.body().string())
  end})
end)

function mSetText(id,m)
  Thread(Runnable{
    run = function()
      this.runOnUiThread(Runnable{
        run = function()
          YoYo.with(Techniques.Bounce).duration(1000).playOn(mainProgress)
          YoYo.with(Techniques.Bounce).duration(1000).playOn(id)
          id.setText(m)
      end})
  end}).start()
end

function mLoadTable(json)
  Thread(Runnable{
    run = function()
      this.runOnUiThread(Runnable{
        run = function()
          superTable=cjson.decode(json)
          --隐藏加载提示
          mainProgress.setVisibility(8)
          optionText.setVisibility(8)
          --刷新适配器
          adapterm.notifyDataSetChanged()
          --RV显示动画
          YoYo.with(Techniques.FadeIn).duration(200).playOn(recycler_view)
      end})
  end}).start()
end


--本地RecyclerView部分
function loadLocalList()

  local item_app=
  {LinearLayoutCompat,
    Orientation=0,
    layout_width="fill",
    layout_height="wrap",
    id="contents",
    {AppCompatImageView,
      layout_marginTop="12dp",
      layout_marginBottom="12dp",
      layout_marginLeft="16dp",
      layout_width="38dp",
      layout_height="38dp",
      id="icon",
    },
    {LinearLayoutCompat,
      layout_gravity="center",
      layout_marginTop="12dp",
      layout_marginBottom="12dp",
      layout_marginLeft="8dp",
      Orientation=1,
      layout_width="match_parent",
      layout_height="match_parent",
      {MaterialTextView,
        textSize="14sp",
        id="name",
      },
      {MaterialTextView,
        textSize="12sp",
        id="packname",
      },
    }
  }

  AppList={}
  adapter_app=LuaCustRecyclerAdapter(AdapterCreator({
    getItemCount=function()
      return #AppList
    end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      holder=LuaCustRecyclerHolder(loadlayout(item_app,views))
      holder.view.setTag(views)
      return holder
    end,
    onBindViewHolder=function(holder,position)
      view=holder.view.getTag()
      local localapp=AppList[position+1]
      view.name.Text=localapp.app_name
      view.packname.Text=localapp.packageName
      local options = RequestOptions()
      .placeholder(getFileDrawable("preload"))
      .skipMemoryCache(true)
      .diskCacheStrategy(DiskCacheStrategy.NONE);
      Glide.with(activity).asDrawable().load(localapp.app_icon).apply(options).into(view.icon)
      view.contents.backgroundResource=rippleRes.resourceId
      view.contents.onClick=function(v)
        local popMenu={
          ["更多"]={
            ["暂无"]=function()
            end,
          },
          ["打开"]=function()
            manager = activity.getPackageManager()
            open = manager.getLaunchIntentForPackage(localapp.packageName)
            this.startActivity(open)
          end,
        }
        showPopMenu(popMenu,v,localapp.app_name)
      end
    end,
  }))
  recycler_app.setAdapter(adapter_app)
  recycler_app.setLayoutManager(LinearLayoutManager(this))

  function CreateAppAdapter(list)
    AppList=list()
    adapter_app.notifyDataSetChanged()
    AppoptionText.setVisibility(8)
    AppProgress.setVisibility(8)
  end

  thread(function()
    require "import"
    import "android.content.pm.ApplicationInfo"
    local packageMgr = activity.PackageManager
    local packages = packageMgr.getInstalledPackages(0)
    local data = {}
    local count = 0

    while count~= #packages do
      local packageInfo = packages[count]
      local appInfo = packageInfo.applicationInfo
      local packageName = packageInfo.packageName
      local appInfo = packageInfo.applicationInfo

      -- 排除列表中的系统应用
      if (appInfo.flags & ApplicationInfo.FLAG_SYSTEM) <= 0 then
        local label = appInfo.loadLabel(packageMgr)
        local icon = appInfo.loadIcon(packageMgr)
        table.insert(data, #data + 1,
        {app_icon = icon,
          app_name = label,
          packageName = packageName,
        })
      end
      count=count+1
    end

    function returnTable()
      return data
    end

    call("CreateAppAdapter",returnTable)
  end)
end

--退出应用
_exit=0
function onKeyDown(code,event)
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
    if _exit+2 > tonumber(os.time()) then
      activity.finish()
     else
      local _snack=Snackbar.make(vpg,"再次返回以退出",Snackbar.LENGTH_SHORT)
      .setAction("退出", View.OnClickListener{
        onClick=function(v)
          activity.finish()
        end
      })
      .show();
      if vpg.getCurrentItem() == 1 then
        _snack.setAnchorView(fab)
       else
        _snack.setAnchorView(bottombar)
      end
      _exit=tonumber(os.time())
    end
    return true
  end
end
--回收内存
collectgarbage("collect")