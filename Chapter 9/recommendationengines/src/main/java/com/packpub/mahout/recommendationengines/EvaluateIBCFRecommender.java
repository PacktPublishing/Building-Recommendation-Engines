package com.packpub.mahout.recommendationengines;

import java.io.File;
import java.io.IOException;

import org.apache.mahout.cf.taste.common.TasteException;
import org.apache.mahout.cf.taste.eval.RecommenderBuilder;
import org.apache.mahout.cf.taste.eval.RecommenderEvaluator;
//import org.apache.mahout.cf.taste.impl.eval.AverageAbsoluteDifferenceRecommenderEvaluator;
import org.apache.mahout.cf.taste.impl.eval.RMSRecommenderEvaluator;
import org.apache.mahout.cf.taste.impl.model.file.FileDataModel;
import org.apache.mahout.cf.taste.impl.recommender.GenericItemBasedRecommender;
import org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity;
import org.apache.mahout.cf.taste.model.DataModel;
import org.apache.mahout.cf.taste.recommender.Recommender;
import org.apache.mahout.cf.taste.similarity.ItemSimilarity;

public class EvaluateIBCFRecommender {

	public static void main(String[] args) throws IOException, TasteException {

		DataModel model = new FileDataModel(new File("data/dataset.csv"));
		//Average Absolute Difference Recommender Evaluator
		//RecommenderEvaluator evaluator = new AverageAbsoluteDifferenceRecommenderEvaluator();
		
		//RMS Recommender Evaluator
		RecommenderEvaluator evaluator = new RMSRecommenderEvaluator();
		RecommenderBuilder builder = new RecommenderBuilder() {
		public Recommender buildRecommender(DataModel model)
		throws TasteException {
			ItemSimilarity similarity = new PearsonCorrelationSimilarity (model);
			return
			new GenericItemBasedRecommender (model,similarity);
			}
			};
			double score = evaluator.evaluate(builder, null, model, 0.7, 1.0);
			System.out.println(score);

	}

}
