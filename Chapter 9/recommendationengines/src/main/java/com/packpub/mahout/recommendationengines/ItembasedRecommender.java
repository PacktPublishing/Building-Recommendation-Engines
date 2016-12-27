package com.packpub.mahout.recommendationengines;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.apache.mahout.cf.taste.common.TasteException;
import org.apache.mahout.cf.taste.impl.model.file.FileDataModel;
import org.apache.mahout.cf.taste.impl.recommender.GenericItemBasedRecommender;
import org.apache.mahout.cf.taste.impl.similarity.LogLikelihoodSimilarity;
import org.apache.mahout.cf.taste.model.DataModel;
import org.apache.mahout.cf.taste.recommender.RecommendedItem;
import org.apache.mahout.cf.taste.similarity.ItemSimilarity;


public class ItembasedRecommender {

	public static void main(String[] args) throws TasteException, IOException {
		DataModel model = new FileDataModel(new File("data/dataset.csv"));
    	ItemSimilarity similarity = new LogLikelihoodSimilarity(model);
    	//UserNeighborhood neighborhood = new ThresholdUserNeighborhood(0.1, similarity, model);
    	GenericItemBasedRecommender recommender = new GenericItemBasedRecommender(model, similarity);
    	List<RecommendedItem> recommendations = recommender.mostSimilarItems(18, 3);
    	for (RecommendedItem recommendation : recommendations) {
    	  System.out.println(recommendation);
    	}

	}

}
