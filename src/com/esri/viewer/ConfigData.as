///////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010-2011 Esri. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
///////////////////////////////////////////////////////////////////////////
package com.esri.viewer
{

import com.esri.viewer.utils.Hashtable;

import mx.collections.ArrayCollection;

/**
 * ConfigData class is used to store configuration information from the config.xml file.
 */
public class ConfigData
{
    public var configXML:XML; // Reference to the main config.xml
    public var viewerUI:Array;
    public var controls:Array;
    public var mapAttrs:Array;
    public var basemaps:Array;
	public var grouplayers:Array;
    public var opLayers:Array;
    public var widgetContainers:Array;
    public var widgets:Array;
    public var widgetIndex:Array;
    public var styleAlpha:Number;
    public var styleColors:Array;
    public var font:Object;
    public var titleFont:Object;
    public var subTitleFont:Object;
    public var geometryService:Object;
    public var bingKey:String;
    public var proxyUrl:String;
    public var layoutDirection:String;
    public var webMapLayers:ArrayCollection;
	/**
	 * 系统所拥有的有权限的模块列表
	 * <p>王红亮，2013-3-5</p>
	 */
	//public var checkedModules:Array;
	
	/**
	 * 是否授权
	 * @author 温杨彪
	 **/
	public var isAuthorization:Boolean;
	
	/**
	 * 当前登录用户
	 * <p>
	 * 温杨彪；2012-4-9
	 **/
	public var loginUser:LoginUser;
	
	/**
	 * url传过来的参数
	 **/
	public var urlParam:Object;
	
	/**
	 * url传值定义的操作处理，用于从外部通过url查询字符串直接调用电子地图中的某个模块
	 **/
	public var urlOperation:Hashtable;
	
	/**
	 * 
	 **/
	public var baseLayerLoadCompeleted:Boolean;
    public function ConfigData()
    {
        viewerUI = [];
        controls = [];
        mapAttrs = [];
        basemaps = [];
        opLayers = [];
        widgets = [];
		grouplayers=[];
        widgetContainers = []; //[i]={container, widgets]
        widgetIndex = []; //[i]={container, inx}
        styleAlpha = 0.8;
        styleColors = [];
        geometryService = {}; // { url: "foo", token: "123", useproxy: false }
		loginUser = null;
		urlOperation = null;
		urlParam = null;
		baseLayerLoadCompeleted = false;
    }
}

}
