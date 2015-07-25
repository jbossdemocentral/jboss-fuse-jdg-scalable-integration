package org.jboss.demo.jdg.model;

import java.io.Serializable;
import java.util.Date;

import org.apache.camel.dataformat.bindy.annotation.CsvRecord;
import org.apache.camel.dataformat.bindy.annotation.DataField;

@CsvRecord( separator = ",", skipFirstLine = true )
public class StockHistoryQuote implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6460060221946124669L;

	@DataField(pos=1 , required=true, pattern="yyyy-MM-dd")
	Date quoteDate;
	
	@DataField(pos=2 , required=true)
	double open;
	
	@DataField(pos=3 , required=true)
	double high;
	
	@DataField(pos=4 , required=true)
	double low;
	
	@DataField(pos=5 , required=true, pattern="dd-MM-yyyy")
	double close;
	
	@DataField(pos=6 , required=true)
	int volume;
	
	@DataField(pos=7 , required=true)
	double adjClose;

	public Date getQuoteDate() {
		return quoteDate;
	}

	public void setQuoteDate(Date quoteDate) {
		this.quoteDate = quoteDate;
	}

	public double getOpen() {
		return open;
	}

	public void setOpen(double open) {
		this.open = open;
	}

	public double getHigh() {
		return high;
	}

	public void setHigh(double high) {
		this.high = high;
	}

	public double getLow() {
		return low;
	}

	public void setLow(double low) {
		this.low = low;
	}

	public double getClose() {
		return close;
	}

	public void setClose(double close) {
		this.close = close;
	}

	public int getVolume() {
		return volume;
	}

	public void setVolume(int volume) {
		this.volume = volume;
	}

	public double getAdjClose() {
		return adjClose;
	}

	public void setAdjClose(double adjClose) {
		this.adjClose = adjClose;
	}
	
	public long getTimeStampinLong(){
		return this.quoteDate.getTime();
	}
	
	public String toString(){
		return "quoteDate:["+quoteDate+"]"+
			   " open:["+open+"]"+
			   " high:["+high+"]"+
			   " low:["+low+"]"+
			   " close:["+close+"]"+
			   " adjClose:["+adjClose+"]"+
			   " volume:["+volume+"]";
		
	}
	
	
	
}
