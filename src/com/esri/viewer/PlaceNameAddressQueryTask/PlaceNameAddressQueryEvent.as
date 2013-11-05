package com.esri.viewer.PlaceNameAddressQueryTask
{
	import flash.events.Event;
	
	public final class PlaceNameAddressQueryEvent extends Event
	{
		public static const FULL_TEXT_SEARCH_COMPLETE:String = "fullTextSearchComplete";
		public var lastQueryResult:PlaceNameAddressQueryResult;
		public function PlaceNameAddressQueryEvent(type:String, solveResult:PlaceNameAddressQueryResult)
		{
			super(type);
			this.lastQueryResult = solveResult as PlaceNameAddressQueryResult;
		}
	}
}