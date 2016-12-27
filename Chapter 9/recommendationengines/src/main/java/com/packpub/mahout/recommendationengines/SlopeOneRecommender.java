package com.packpub.mahout.recommendationengines;

import java.io.File;
import java.io.IOException;

import org.apache.mahout.cf.taste.common.Weighting;
import org.apache.mahout.cf.taste.impl.model.file.FileDataModel;
import org.apache.mahout.cf.taste.model.DataModel;
import org.apache.mahout.cf.taste.recommender.Recommender;

public class SlopeOneRecommender {

	public static void main(String[] args) throws IOException {
		DataModel model = new FileDataModel(new File("data/dataset.csv"));  
		Recommender recommender = (Recommender) new SlopeOneRecommender();

	}

}
