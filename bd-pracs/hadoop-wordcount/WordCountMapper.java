import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class WordCountMapper
        extends Mapper<LongWritable, Text, Text, IntWritable> {

    private static final IntWritable ONE = new IntWritable(1);
    private final Text word = new Text();

    @Override
    public void map(
            LongWritable key,
            Text value,
            Context context) throws IOException, InterruptedException {

        // Convert the input line to a String
        String line = value.toString();

        // Split the line into words based on whitespace
        String[] words = line.split("\\s+");

        // Emit (word, 1) for each word
        for (String w : words) {
            if (!w.isEmpty()) {
                word.set(w);
                context.write(word, ONE);
            }
        }
    }
}
