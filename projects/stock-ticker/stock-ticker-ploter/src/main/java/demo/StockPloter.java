package demo;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.io.IOException;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.swing.JFrame;
import javax.swing.JPanel;

import org.infinispan.Cache;
import org.infinispan.commons.util.CloseableIteratorCollection;
import org.infinispan.manager.DefaultCacheManager;
import org.infinispan.manager.EmbeddedCacheManager;
import org.jboss.demo.jdg.model.StockQuote;

public class StockPloter extends JPanel {

	private static final long serialVersionUID = -6701507664970285335L;

	private static final double RELATIV_SCREEN_AREA = 0.95;
	public static final int WIDTH = 520;
	public static final int HEIGHT = 400;
	private static final int NUM_ELEMENTS = 500;
	
	private int maxStockValue = 500;
	public  int pixelsPerPoint = Math.round(WIDTH-20/NUM_ELEMENTS);


	
	
	public static final String cacheName = "stock-ticker-cache";
	public static final String[] stockSymbols = {"ABC"};
	
	private ArrayDeque<StockQuote> stockData = new ArrayDeque<StockQuote>(NUM_ELEMENTS);
	
	Cache<String,StockQuote> cache;

	public StockPloter() throws IOException {
		super();
		EmbeddedCacheManager cacheManager;
		cacheManager = new DefaultCacheManager("infinispan.xml");
		Cache<String,StockQuote> cache = cacheManager.getCache(cacheName);
		cache.addListener(new StockJDGReciever(this));
		cache.start();
		
		CloseableIteratorCollection<StockQuote> values = cache.values();
		System.out.format("The cache container has %d entries\n",values.size());
		List<StockQuote> list = new ArrayList<StockQuote>(values);
		Collections.sort( list , new Comparator< StockQuote >( ){
			@Override
			public int compare(StockQuote o1, StockQuote o2) {
				return o1.getId()-o2.getId();
			}
		} );
		
		for(StockQuote quote : (list.size()<NUM_ELEMENTS) ? list : (list.subList(list.size()-NUM_ELEMENTS, list.size()))) {
			if(quote.getValue()>maxStockValue)
				maxStockValue=quote.getValue();
			this.stockData.add(quote);
		}
		this.repaint();
		
	}


	public void paintComponent(Graphics g) {
		Graphics2D g2 = (Graphics2D) g;
		g2.setColor(Color.RED);
		g.setFont(new Font(Font.SANS_SERIF,Font.BOLD,10));
		
		pixelsPerPoint = getWidth()/NUM_ELEMENTS;
		
		int oldValue=-1;
		
		if (stockData!=null && stockData.size()>0) {
			int x=0;
			for (StockQuote quote : stockData) {
				if (oldValue > 0) {
					int newValue = quote.getValue();
					g2.drawLine(x, scaleAndPositionValue(oldValue), x+=pixelsPerPoint, scaleAndPositionValue(newValue));
				}
				oldValue = quote.getValue();
			}
			 
			int currentValue = stockData.getLast().getValue();
			String currentValueStr = String.format("CurrentValue: %d", currentValue);
			g.drawChars(currentValueStr.toCharArray(), 0, currentValueStr.length(), getWidth()/2-50, getHeight()-10);
		}
	}
	
	
	private int scaleAndPositionValue(int value) {
		double heightInDrawArea = this.getHeight()*RELATIV_SCREEN_AREA;
		double pixelsPerValuePoint = heightInDrawArea/maxStockValue;
		int middleOfPanel=(int) Math.round(this.getHeight()/2);
		int scaledValue = (int) Math.round(value*pixelsPerValuePoint);
		int positionedScaledValue = middleOfPanel - (scaledValue - (int) Math.round(heightInDrawArea/2));
//		System.out.format("Scaled value %d to x-cordinate %d\n",value,positionedScaledValue);
		return positionedScaledValue;
	}
	
	public void add(StockQuote quote) {
		this.stockData.add(quote);
		if(stockData.size()>NUM_ELEMENTS) {
			stockData.removeFirst(); //We will only save enough data to print on the screen
		}
		if(quote.getValue()>maxStockValue)
			maxStockValue=quote.getValue();
		this.repaint();
	}

	public static void main(String[] args) throws IOException {
		//String symbol = JOptionPane.showInputDialog("Enter Ticker Symbol:");
		String symbol = stockSymbols[0];
		if (symbol == null)
			System.exit(0); // quit if user hit Cancel
		
		

		StockPloter panel = new StockPloter();	
		JFrame frame = new JFrame(String.format("Data for stock %s", symbol));
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		panel.setBackground(Color.WHITE);
		frame.setBackground(Color.WHITE);
		frame.add(panel);
		frame.setSize(WIDTH, HEIGHT); 
		frame.setVisible(true);
		
	}
	
}
