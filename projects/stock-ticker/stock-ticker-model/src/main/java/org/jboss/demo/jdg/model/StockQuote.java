package org.jboss.demo.jdg.model;

import java.io.Serializable;

public class StockQuote implements Serializable{
	private static final long serialVersionUID = 8651457763762868219L;
	
	private String custId;
	private int volume;
	
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
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	@Override
	public String toString() {
		return String.format("%s=%s", this.custId,this.volume);
	}
	
	
	
	
}
