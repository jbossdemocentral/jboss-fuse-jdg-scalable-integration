package org.jboss.demo.jdg;

import java.util.Random;

import org.jboss.demo.jdg.model.StockQuote;

public class RandomStockTicker {

	private Random r = new Random();
	
	private int idcounter=0;
	
	private int lastValue=200;
	
	public StockQuote nextTick() {
		StockQuote quote = new StockQuote();
		quote.setId(idcounter++);
		quote.setSymbol("ABC");
		int newValue = lastValue + (r.nextInt(30)-14);
		newValue = (newValue < 1 ? 1 :  newValue) ; //Make sure that we are not getting negative numbers;
		quote.setValue(newValue);
		lastValue = newValue;
		return quote;
	}	
}
