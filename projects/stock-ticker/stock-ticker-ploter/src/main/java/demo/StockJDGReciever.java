package demo;

import org.infinispan.notifications.Listener;
import org.infinispan.notifications.cachelistener.annotation.CacheEntryCreated;
import org.infinispan.notifications.cachelistener.annotation.CacheEntryModified;
import org.infinispan.notifications.cachelistener.event.CacheEntryCreatedEvent;
import org.infinispan.notifications.cachelistener.event.CacheEntryModifiedEvent;
import org.infinispan.notifications.cachelistener.event.Event;
import org.jboss.demo.jdg.model.StockQuote;

@Listener
public class StockJDGReciever {
	
	private StockPloter ploter;

	public StockJDGReciever(StockPloter ploter) {
		super();
		this.ploter = ploter;
	}

	@CacheEntryCreated
	@CacheEntryModified
	public void handle(Event<String,StockQuote> event) {	
		if( !event.isPre() && ( event.getType()==Event.Type.CACHE_ENTRY_MODIFIED || event.getType()==Event.Type.CACHE_ENTRY_CREATED) ) {
			StockQuote nextValue = event.getType()==Event.Type.CACHE_ENTRY_CREATED ? ((CacheEntryCreatedEvent<String,StockQuote>) event).getValue() : ((CacheEntryModifiedEvent<String,StockQuote>)event).getValue();
			ploter.add(nextValue);
			
		}
	}
}
