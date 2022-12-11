require "import"
import {
  "android.os.*",
  "android.widget.*",
  "android.view.*",
  "android.animation.LayoutTransition",
  "android.content.Intent",
  "android.content.res.ColorStateList",
  "android.graphics.BitmapFactory",
  "android.graphics.drawable.GradientDrawable$Orientation",
  "android.graphics.drawable.Drawable",
  "android.graphics.drawable.BitmapDrawable",
  "android.graphics.drawable.ColorDrawable",
  "android.graphics.Typeface",
  "android.util.TypedValue",
  "android.net.Uri",
  "java.io.FileInputStream",

  "androidx.appcompat.widget.LinearLayoutCompat",
  "androidx.appcompat.widget.AppCompatImageView",
  "androidx.core.widget.NestedScrollView",
  "androidx.coordinatorlayout.widget.CoordinatorLayout",
  "androidx.viewpager.widget.ViewPager",
  "androidx.viewpager.widget.ViewPager$DecorView",
  "androidx.recyclerview.widget.RecyclerView",
  "androidx.recyclerview.widget.LinearLayoutManager",
  "androidx.swiperefreshlayout.widget.SwipeRefreshLayout",

  "com.google.android.material.appbar.AppBarLayout",
  "com.google.android.material.appbar.MaterialToolbar",
  "com.google.android.material.appbar.CollapsingToolbarLayout",
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

}


--顶栏菜单点击监听
import "androidx.appcompat.widget.Toolbar$OnMenuItemClickListener"
toolbar.setOnMenuItemClickListener(OnMenuItemClickListener{
  onMenuItemClick=function(item)
  switch item.getItemId() do
     case 0
      local SelectLayout=
      {
        LinearLayoutCompat,
        orientation="vertical",
        {
          RadioGroup,
          id="jsonGroup",
          orientation="vertical",
          layout_width="match_parent";
          layout_margin="20dp",
          {
            MaterialRadioButton,
            text="Project HSH(默认)",
            onClick=function()
              dataInput("https://raw.githubusercontent.com/projecthsh/Project-HSH/master/index-1.json","settings","JSON")
            end,
          },
          {
            MaterialRadioButton,
            text="Cyancat000",
            onClick=function()
              dataInput("https://raw.githubusercontent.com/Cyancat000/Project-HSH/master/index-1.json","settings","JSON")
            end,
          },
          {
            MaterialRadioButton,
            text="znzsofficial",
            onClick=function()
              dataInput("https://raw.githubusercontent.com/znzsofficial/Project-HSH/master/index-1.json","settings","JSON")
            end,
          },
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
            text="当前地址:\n"..url_json.."\n\n设置重启应用后生效",
            Typeface=Typeface.defaultFromStyle(Typeface.BOLD);
            onClick=function()
              activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(tostring(url_json))
            end
          },
        },
      }
      MaterialAlertDialogBuilder(this)
      .setTitle("更换JSON源")
      .setView(loadlayout(SelectLayout))
      .setPositiveButton("确定",function()
        hideInput(jsonEdit)
      end)
      .show()
      jsonEdit.addTextChangedListener{
        onTextChanged=function()
          dataInput(tostring(jsonEdit.getText()),"settings","JSON")
        end
      }
     case 1
      activity.finish()
    end
  end
})

fab.setVisibility(8)
--ViewPager和BottomNavigationView联动
vpg.setOnPageChangeListener(ViewPager.OnPageChangeListener{
  onPageSelected=function(v)
    bottombar.getMenu().getItem(v).setChecked(true)
    if v~=1 then
      YoYo.with(Techniques.ZoomOut).duration(200).playOn(fab)
      task(200,function()fab.setVisibility(8)end)
      if v==0 and isLoaded~=true then
        --显示本地列表
        isLoaded=true
        loadLocalList()
        collectgarbage("collect")
      end
     else
      fab.setVisibility(0)
      YoYo.with(Techniques.ZoomIn).duration(200).playOn(fab)
    end
end})


bottombar.setOnNavigationItemSelectedListener(BottomNavigationView.OnNavigationItemSelectedListener{
  onNavigationItemSelected = function(item)
    vpg.setCurrentItem(item.getItemId())
    return true
end})
--默认主页
bottombar.setSelectedItemId(2)
--一行解决控件联动。使用LuaPagerAdapter新增的构造方法，支持在布局表中设置标题!
mtab.setupWithViewPager(cvpg)

--给主页面ProgressBar勉强设置一个动画
YoYo.with(Techniques.FadeIn).duration(500).playOn(mainProgress)
YoYo.with(Techniques.FadeIn).duration(500).playOn(optionText)

SelectDownload.onClick=function()
  local onSelectLayout=
  {
    LinearLayoutCompat,
    orientation="vertical",
    layout_width="match_parent";
    padding="20dp",
    {
      TextInputEditText;
      layout_width="match_parent";
      layout_gravity="center",
      tooltipText="输入下载路径",
      text=sp.getString("FileAddress",""),
      id="downloadEdit";
    },
    {
      MaterialTextView,
      layout_marginTop="10dp",
      tooltipText=sp.getString("FileAddress",""),
      text="当前路径为"..sp.getString("FileAddress","").."\n仅支持下载到Android内部存储\n\n对于Android10以上用户建议通过SAF进一步授予对应文件夹权限",
    },
    {
      MaterialTextView,
      layout_marginTop="10dp",
      text="点击此处打开SAF框架",
      textColor=primaryc,
      backgroundResource=rippleRes.resourceId,
      Typeface=Typeface.defaultFromStyle(Typeface.BOLD);
      onClick=function()
        import{
          "android.net.Uri",
          "android.provider.DocumentsContract",
          "androidx.documentfile.provider.DocumentFile",
        }
        uri=Uri.parse("content://com.android.externalstorage.documents/tree/primary%3A")
        intent=Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION|Intent.FLAG_GRANT_WRITE_URI_PERMISSION|Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION|Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
        intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI,DocumentFile.fromTreeUri(activity,uri).getUri())
        activity.startActivity(intent)
      end,
    },
  }
  MaterialAlertDialogBuilder(this)
  .setTitle("文件下载路径")
  .setView(loadlayout(onSelectLayout))
  .setPositiveButton("确定",function()
    hideInput(downloadEdit)
    SelectDownload.getChildAt(0).getChildAt(1).setText("当前下载路径"..sp.getString("FileAddress",""))
  end)
  .show()
  downloadEdit.addTextChangedListener{
    onTextChanged=function()
      dataInput(tostring(downloadEdit.getText()),"settings","FileAddress")
    end
  }
end

Materialswitch.setOnCheckedChangeListener{
  onCheckedChanged=function()
    dataNegate("settings","MYswitch")
    print("切换后需要重启应用以生效")
  end
}

autoSwitch.setOnCheckedChangeListener{
  onCheckedChanged=function()
    dataNegate("settings","autoInstall")
  end
}

suSwitch.setOnCheckedChangeListener{
  onCheckedChanged=function()
    dataNegate("settings","suInstall")
  end
}

licenseShow.onClick=function(v)
  local MarkDownLayout=
  {
    LinearLayoutCompat,
    layout_width="match_parent";
    padding="12dp";
    {
      MaterialCardView,
      radius="16dp",
      layout_width="match_parent";
      {
        LuaWebView;
        id="WebView";
        layout_width="-1";
        layout_height="-1";
        ProgressBarEnabled=false,
      },
    },
  }
  MaterialAlertDialogBuilder(this)
  .setTitle("开源许可")
  .setView(loadlayout(MarkDownLayout))
  .setPositiveButton("确定",nil)
  .show()
  --设置WebView显示动画
  YoYo.with(Techniques.FadeIn).duration(1000).playOn(WebView)
  --rawio获取md内容
  rawio=require "rawio"
  local Markdown4jProcessor=luajava.bindClass("org.markdown4j.Markdown4jProcessor")
  local content = rawio.iotsread(activity.getLuaDir().."/license.md","r")
  WebView.loadDataWithBaseURL("",Markdown4jProcessor().process(content),"text/html","utf-8",nil)
  function isNightMode()
    local configuration = activity.getResources().getConfiguration();
    return configuration.uiMode+1==configuration.UI_MODE_NIGHT_YES or configuration.uiMode-1==configuration.UI_MODE_NIGHT_YES or configuration.uiMode==configuration.UI_MODE_NIGHT_YES
  end
  WebView.setWebViewClient({
    onPageFinished = function(view,url)
      if isNightMode() then
        WebView.evaluateJavascript([[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#212121 !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]],nil)
       else
      end
    end,
    shouldOverrideUrlLoading=function(view,url)
      local intent = Intent()
      intent.setAction("android.intent.action.VIEW")
      local content_url = Uri.parse(url)
      intent.setData(content_url)
      activity.startActivity(intent)
      return true
    end
  })
  WebView.onLongClick = function()
    return true
  end
end

documentShow.onClick=function(v)
  MaterialAlertDialogBuilder(this)
  .setTitle("使用协议和隐私政策")
  .setMessage(getPrivatePrivacy())
  .setPositiveButton("确定",nil)
  .show()
end

cjson=require "cjson"
--主RecyclerAdapter部分
local Mitem={
  LinearLayoutCompat;
  orientation='vertical';
  layout_width='fill';
  layout_height='wrap';
  id="contents",
  padding='10dp';
  {LinearLayoutCompat,
    Orientation=0,
    layout_width="fill",
    layout_height="wrap",
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
      layout_marginLeft="12dp",
      Orientation=1,
      {MaterialTextView,
        textSize="18sp",
        id="title",
      },
      {MaterialTextView,
        ellipsize='end';
        singleLine=true,
        textSize="13sp",
        id="profile",
      },
      {MaterialTextView,
        textSize="13sp",
        id="pack",
      },
    },
  },
};

superTable={}
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
    view.pack.Text=app.packge
    options = RequestOptions()
    .placeholder(getFileDrawable("preload"))
    .diskCacheStrategy(DiskCacheStrategy.AUTOMATIC);
    Glide.with(activity).asDrawable().load(app.logo).apply(options).into(view.icon)
    view.contents.backgroundResource=rippleRes.resourceId
    view.contents.onClick=function(v)
      --点击显示PopupWindow
      local popMenu={
        ["下载"]=function()
          if app.link=="" or app.link==nil then
            print(app.name.."暂无下载链接")
           else
            if isDownloading==true then
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
        if flag~= true then
          requestPermissions(requirePermissions)
          print("请授予存储权限后尝试下载")
          return true
        end

        isDialogCanceled=nil

        downloadLayout=
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


        dialog=MaterialAlertDialogBuilder(this)
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
          dialog.cancel()
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
            Snackbar.make(vpg,app.name.."下载完成",Snackbar.LENGTH_SHORT)
            .setAnchorView(bottombar)
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

--导入okhttp
local OkHttpClient,OkHttpRequest,OkHttpCallback=luajava.bindClass"okhttp3.OkHttpClient",luajava.bindClass"okhttp3.Request",luajava.bindClass"okhttp3.Callback"
--请求辅助类
mRequest = OkHttpRequest.Builder()
.url(url_json)
.build();
--异步请求
mClient = OkHttpClient()
mCall = mClient.newCall(mRequest)
mCall.enqueue(OkHttpCallback{
  onFailure=function(call,e)
    mSetText(optionText,"连接失败，请检查你的网络设置或JSON源")
  end,
  onResponse=function(call,response)
    mLoadTable(response.body().string())
end})

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
          mainProgress.setVisibility(8)
          optionText.setVisibility(8)
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


  function CreateAppAdapter(list)
    AppList=list()
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
        options = RequestOptions()
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
exit=0
function onKeyDown(code,event)
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
    if exit+2 > tonumber(os.time()) then
      activity.finish()
     else
      Snackbar.make(vpg,"再次返回以退出",Snackbar.LENGTH_SHORT)
      .setAnchorView(bottombar)
      .setAction("退出", View.OnClickListener{
        onClick=function(v)
          activity.finish()
        end
      })
      .show();
      exit=tonumber(os.time())
    end
    return true
  end
end
--回收内存
collectgarbage("collect")