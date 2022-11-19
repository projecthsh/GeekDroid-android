require "import"
import {
  "android.os.*",
  "android.widget.*",
  "android.view.*",
  "android.content.Intent",
  "android.graphics.BitmapFactory",
  "android.graphics.drawable.GradientDrawable$Orientation",
  "android.graphics.drawable.Drawable",
  "android.graphics.drawable.BitmapDrawable",
  "android.graphics.drawable.ColorDrawable",
  "android.graphics.Typeface",
  "android.animation.LayoutTransition",
  "android.util.TypedValue",
  "android.net.Uri",
  "java.io.FileInputStream",

  "androidx.core.widget.NestedScrollView",
  "androidx.coordinatorlayout.widget.CoordinatorLayout",
  "androidx.viewpager.widget.ViewPager",
  "androidx.viewpager.widget.ViewPager$DecorView",
  "androidx.recyclerview.widget.RecyclerView",
  "androidx.recyclerview.widget.LinearLayoutManager",
  "androidx.swiperefreshlayout.widget.SwipeRefreshLayout",
  "androidx.appcompat.widget.LinearLayoutCompat",
  "androidx.appcompat.widget.AppCompatImageView",

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

  "github.daisukiKaffuChino.LuaCustRecyclerAdapter",
  "github.daisukiKaffuChino.AdapterCreator",
  "github.daisukiKaffuChino.LuaCustRecyclerHolder",
  "github.daisukiKaffuChino.utils.LuaThemeUtil",

  "com.daimajia.androidanimations.library.Techniques",
  "com.daimajia.androidanimations.library.YoYo",
  "com.bumptech.glide.Glide",
  "com.bumptech.glide.request.RequestOptions",
  "com.bumptech.glide.load.engine.DiskCacheStrategy",
  "me.everything.android.ui.overscroll.*",

  "mods.fun",
  "mods.setting",
  "mods.popup",
  "mods.document",
}

--设置主题
activity.setTheme(R.style.Theme_ReOpenLua_Material3)
if sp.getString("MYswitch",nil)=="开启" then
  import"com.google.android.material.color.DynamicColors"
  DynamicColors.applyIfAvailable(this)
end

--初始化颜色
--为了使深色主题效果正常，请不要使用硬编码颜色!
local themeUtil=LuaThemeUtil(this)
MDC_R=luajava.bindClass"com.google.android.material.R"
surfaceColor=themeUtil.getColorSurface()
backgroundc=themeUtil.getColorBackground()
surfaceVar=themeUtil.getColorSurfaceVariant()
titleColor=themeUtil.getTitleTextColor()
primaryc=themeUtil.getColorPrimary()
primarycVar=themeUtil.getColorPrimaryVariant()

--初始化ripple
rippleRes = TypedValue()
activity.getTheme().resolveAttribute(android.R.attr.selectableItemBackground, rippleRes, true)

function getFileDrawable(file)
  fis = FileInputStream(activity.getLuaDir().."/res/"..file..".png")
  bitmap = BitmapFactory.decodeStream(fis)
  return BitmapDrawable(activity.getResources(), bitmap)
end

--隐藏输入法
function hiddenInputMethod(inputid)
  import "android.view.inputmethod.InputMethodManager"
  activity.getSystemService(Context.INPUT_METHOD_SERVICE).hideSoftInputFromWindow(inputid.getWindowToken(),0)
end

layout={
  CoordinatorLayout,
  layout_width="fill",
  layout_height="fill",
  {
    AppBarLayout,
    layout_width="fill",
    layout_height="100dp",
    {
      CollapsingToolbarLayout,
      layout_width="fill",
      layout_height="fill",
      layout_scrollFlags="scroll|exitUtilCollapsed|snap",
      title="GeekDroid",
      background=ColorDrawable(surfaceVar),
      --expandedTitleColor="#FFFFFF",
      --collapsedTitleTextColor="#FFFFFF",
      --展开 和 收起 时的标题颜色
      {
        MaterialToolbar,
        id="toolbar",
        layout_collapseMode="pin",
        background=ColorDrawable(surfaceVar),
        layout_width="fill",
        layout_height="56dp",
      },
    },
  },
  {
    NestedScrollView,
    layout_width="fill",
    layout_height="fill",
    layout_behavior="@string/appbar_scrolling_view_behavior",
    fillViewport="true",
    backgroundColor=backgroundc,
    {
      LinearLayoutCompat,
      id="content",
      layout_width="fill",
      layout_height="fill",
      orientation="vertical",
      --[
      {
        ViewPager,
        id="vpg",
        layout_width="fill",
        layout_height="fill",
        pages={
          "page_file",
          "page_find",
          "page_home",
          "page_json",
          "page_setting",
        },
      },
    },
  },
  {
    BottomNavigationView,
    id="bottombar",
    layout_gravity="bottom",
    layout_width="fill",
    layout_height="wrap",
  },
  {
    ExtendedFloatingActionButton,
    id="fab",
    text="More",
    onClick="onClickFab",
    icon=getFileDrawable("outline_info_black_24dp"),
    layout_gravity="bottom|end",
    layout_marginBottom="110dp",
    layout_marginEnd="16dp",
  },
}

--设置布局
activity.setContentView(loadlayout(layout))
--隐藏自带ActionBar
activity.getSupportActionBar().hide()
--配置状态栏颜色
local window = activity.getWindow()
window.setStatusBarColor(surfaceVar)
window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
window.setNavigationBarColor(surfaceVar)

local bottombarBehavior=luajava.bindClass"com.google.android.material.behavior.HideBottomViewOnScrollBehavior"
bottombar.layoutParams.setBehavior(bottombarBehavior())
bottombar.setLabelVisibilityMode(0)--设置tab样式

--设置底栏项目
local bottomMenu={"本地","发现","主页","创建","设置"}
for key,v in ipairs(bottomMenu) do
  local itemK=key-1
  --参数分别对应groupid homeid order name
  bottombar.menu.add(0,itemK,itemK,v)
end
--设置底栏图标
local bottomIcon={"content-save","find-replace","home","application-cog","cog"}
for key,v in ipairs(bottomIcon) do
  local itemK=key-1
  --这里findItem取的是home id
  bottombar.menu.findItem(itemK).setIcon(getFileDrawable(v))
end

--MaterialToolbar比普通Toolbar更强大的地方在于，它可以脱离Activity使用
local addToolbarMenu=lambda a,b,c,name:toolbar.menu.add(a,b,c,name)
addToolbarMenu(0,0,0,"换源")
addToolbarMenu(0,1,1,"退出")

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
            text="Project HSH",
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
            text="znzsofficial(默认)",
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
            tooltipText=url_json,
            text="当前地址:"..url_json.."\n重启应用后生效",
            Typeface=Typeface.defaultFromStyle(Typeface.BOLD);
          },
        },
      }
      MaterialAlertDialogBuilder(this)
      .setTitle("更换JSON源")
      .setView(loadlayout(SelectLayout))
      .setPositiveButton("确定",function()
        hiddenInputMethod(jsonEdit)
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

--悬浮按钮点击事件
function onClickFab()
  MaterialAlertDialogBuilder(this)
  .setTitle("More")
  .setIcon(getFileDrawable("outline_info_black_24dp"))
  .setMessage("")
  .setPositiveButton("知道了",nil)
  .show()
end

--[[尝试增大TextInputLayout圆角，虽然不增大也挺好看的
local corii={dp2px(16),dp2px(16),dp2px(16),dp2px(16)}
t1.setBoxCornerRadii(table.unpack(corii))
t2.setBoxCornerRadii(table.unpack(corii))
t3.setBoxCornerRadii(table.unpack(corii))
]]

--设置初始JSON地址
if sp.getString("JSON","")=="" then
  dataInput("https://raw.githubusercontent.com/znzsofficial/Project-HSH/master/index-1.json","settings","JSON")
  url_json="https://raw.githubusercontent.com/znzsofficial/Project-HSH/master/index-1.json"
 else
  url_json=sp.getString("JSON",nil)
end

--设置部分
if sp.getString("MYswitch",nil)=="开启" then
  Materialswitch.setChecked(true)
end

if sp.getString("autoInstall",nil)=="开启" then
  autoSwitch.setChecked(true)
end

Materialswitch.setOnCheckedChangeListener{
  onCheckedChanged=function()
    dataNegate("settings","MYswitch")
    print("切换主题后需要重载页面以生效")
  end
}

autoSwitch.setOnCheckedChangeListener{
  onCheckedChanged=function()
    dataNegate("settings","autoInstall")
  end
}

licenseShow.onClick=function(v)
  MaterialAlertDialogBuilder(this)
  .setTitle("开源许可")
  .setMessage(getDocument("Lua").."\n\n"..getDocument("LuaJava").."\n\n"..getDocument("androlua"))
  .setPositiveButton("确定",nil)
  .show()
end

documentShow.onClick=function(v)
  MaterialAlertDialogBuilder(this)
  .setTitle("使用协议和隐私政策")
  .setMessage(getDocument("policy"))
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


Http.get(url_json,nil,'utf8',nil,function(stateCode,json_table)
  if stateCode ==200 then
    superTable=cjson.decode(json_table)
    mainProgress.setVisibility(8)
    optionText.setVisibility(8)

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
        view.contents.onClick=function()

          function SnackDownload()
            Snackbar.make(vpg,app.name,Snackbar.LENGTH_SHORT)
            .setAnchorView(bottombar)
            .setAction("下载", View.OnClickListener{
              onClick=function(v)


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


                function trans(url,path)
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
                  sp = activity.getSharedPreferences("settings",Context.MODE_PRIVATE)
                  if sp.getString("autoInstall",nil)=="开启" then
                    activity.installApk(path)
                   else
                  end
                end
                function download(url,path)
                  thread(trans,url,path)
                end

                cancel_down.onClick=function()
                  dialog.cancel()
                end

                copy_down.onClick=function()
                  Toast.makeText(activity, "已复制成功",Toast.LENGTH_SHORT).show()
                  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(app.link)
                end

                start_down.onClick=function()
                  if start_down.Text=="下载" then
                    TipDown.Text="下载进程正在启动中..."
                    filePath="/storage/emulated/0/Download/"..app.name..".apk"
                    download(app.link,filePath)
                    progress_down.setVisibility(0)
                   elseif start_down.Text=="安装" then
                    activity.installApk(filePath)
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
                end

              end
            })
            .show();
          end
          if app.link=="" or app.link==nil then
            print(app.name.."暂无下载链接")
           else
            if isDownloading==true then
              if nowDownloading~=app.name then
                print(nowDownloading.."下载任务正在进行")
                return true
               else
                SnackDownload()
              end
             else
              SnackDownload()
            end
          end
        end
      end,
    }))

    recycler_view.setAdapter(adapterm)
    recycler_view.setLayoutManager(LinearLayoutManager(this))
    OverScrollDecoratorHelper.setUpOverScroll(recycler_view, OverScrollDecoratorHelper.ORIENTATION_VERTICAL)
   else
    optionText.Text="连接失败，请检查你的网络设置或JSON源"
  end
end)



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