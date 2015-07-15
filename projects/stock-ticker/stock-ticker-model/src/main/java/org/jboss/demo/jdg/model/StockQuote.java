package org.jboss.demo.jdg.model;

import java.io.Serializable;

public class StockQuote implements Serializable{
	private static final long serialVersionUID = 8651457763762868219L;
	
	private int id;
	private String symbol;
	private int value;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getSymbol() {
		return symbol;
	}
	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}
	public int getValue() {
		return value;
	}
	public void setValue(int value) {
		this.value = value;
	}
	@Override
	public String toString() {
		return String.format("%d: %s=%d", this.id, this.symbol, this.value);
	}
	
	
	
	
}
