package com.esri.viewer.remote
{
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.remoting.RemoteObject;
	
	public class RemoteObject extends mx.rpc.remoting.RemoteObject
	{
		public static var channelUri:String = "digitalMap-amf.endpoint";
		public function RemoteObject(destination:String=null)
		{
			super(destination);
			setupChannelset();
		}
		
		private function setupChannelset():void
		{
			var chanelSet:ChannelSet = new ChannelSet();
			var amfChannel:Channel = new AMFChannel("digitalMap-amf", channelUri);
			chanelSet.addChannel(amfChannel);
			this.channelSet = chanelSet;
		}
	}
}