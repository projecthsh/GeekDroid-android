function showPopMenu(tab,views,title)
  Popup_layout={
    LinearLayoutCompat;
    {
      MaterialCardView;
      id="popContent",
      Elevation="4dp";
      CardBackgroundColor=onsurfaceInv;
      Radius="18dp";
      layout_width="192dp";
      layout_height="-2",
      layout_margin="8dp",
      {
        LinearLayoutCompat;
        layout_height="-1";
        layout_width="-1";
        orientation="vertical",
        id="Popup_list";
      };
    };
  };
  --PopupWindow
  pops=PopupWindow(this)
  --PopupWindow加载布局
  .setContentView(loadlayout(Popup_layout))
  .setWidth(-2)
  .setHeight(-2)
  .setFocusable(true)
  .setOutsideTouchable(true)
  .setBackgroundDrawable(ColorDrawable(0x00000000))

  pops.onDismiss=function()
  end

  --PopupWindow列表项布局
  Popup_list_title={
    LinearLayoutCompat;
    layout_width="-1";
    layout_height="36dp";
    {
      MaterialTextView;
      id="popadp_text";
      Typeface=Typeface.DEFAULT_BOLD,
      textColor=tertiaryc;
      textSize="14sp";
      layout_width="-1";
      layout_height="-1";
      gravity="left|center";
      paddingLeft="16dp";
      Enabled=false,
      --Alpha=0.5,
    };
  };

  if title
    view=loadlayout(Popup_list_title)
    Popup_list.addView(view)
    popadp_text.setText(title)
  end

  Popup_list_item=
  {
    LinearLayoutCompat;
    layout_width="-1";
    layout_height="48dp";
    backgroundColor=backgroundc,
    {
      MaterialTextView;
      id="popadp_text";
      layout_width="-1";
      layout_height="-1";
      textSize="14sp";
      gravity="left|center";
      paddingLeft="16dp";
    };
  };

  for k,v in pairs(tab)

    view=loadlayout(Popup_list_item)
    view.backgroundResource=rippleRes.resourceId;
    if type(v)=="table"

      Popup_list.addView(view)
      popadp_text.setText(k)
      view.onClick=function()
        pops.dismiss()
        task(30,function()
          showPopMenu(v,views,k)
        end)
        -- pops.dismiss()
      end

     elseif type(v)=="function"

      Popup_list.addView(view)
      popadp_text.setText(k)
      view.onClick=function()
        pops.dismiss()
        task(30,function()

          v()
        end)
      end
    end
  end
  pops.showAsDropDown(views)
end

