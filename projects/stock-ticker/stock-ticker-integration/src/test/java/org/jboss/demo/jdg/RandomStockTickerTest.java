package org.jboss.demo.jdg;

import org.junit.Test;

public class RandomStockTickerTest {

	@Test
	public void testNextTick() {
		System.out.println(new RandomStockTicker().nextTick());
		assert(true);
	}

}
