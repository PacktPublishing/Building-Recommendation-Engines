package com.packpub.mahout.recommendationengines;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.apache.mahout.cf.taste.common.TasteException;
import org.apache.mahout.cf.taste.impl.model.file.FileDataModel;
import org.apache.mahout.cf.taste.impl.recommender.svd.ParallelSGDFactorizer;
import org.apache.mahout.cf.taste.impl.recommender.svd.SVDRecommender;
import org.apache.mahout.cf.taste.model.DataModel;
import org.apache.mahout.cf.taste.recommender.RecommendedItem;


public class UserBasedSVDRecommender {

	public static void main(String[] args) throws TasteException, IOException {
		//MF recommender model
    	DataModel model = new FileDataModel(new File("data/recodataset.csv"));   
    	//ALSWRFactorizer factorizer = new ALSWRFactorizer(model, 50, 0.065, 15);
    	ParallelSGDFactorizer factorizer = new ParallelSGDFactorizer(model,10,0.1,1);
    	SVDRecommender recommender = new SVDRecommender(model, factorizer);    	
    	
    	List<RecommendedItem> recommendations = recommender.recommend(2, 3);
    	for (RecommendedItem recommendation : recommendations) {
    	  System.out.println(recommendation);
    	}

	}

}
