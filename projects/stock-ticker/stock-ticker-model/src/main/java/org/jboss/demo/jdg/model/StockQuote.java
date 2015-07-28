package org.jboss.demo.jdg.model;

import java.io.Serializable;
import java.util.Date;

public class StockQuote implements Serializable{
	private static final long serialVersionUID = 8651457763762868219L;
	
	private String custId;
	private int volume;
	private Date buydate;
	private double closeValue;
	
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
	
	public int getVolume() {
		return volume;
	}
	public void setVolume(int volume) {
		this.volume = volume;
	}
	
	public Date getBuydate() {
		return buydate;
	}
	
	public void setBuydate(Date buydate) {
		this.buydate = buydate;
	}
	
	
	public double getCloseValue() {
		return closeValue;
	}
	public void setCloseValue(double closeValue) {
		this.closeValue = closeValue;
	}
	public long getTimeStampinLong(){
		return this.buydate.getTime();
	}
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	@Override
	public String toString() {
		return String.format("%s=%s", this.custId,this.volume);
	}
	
	
	
	
}
