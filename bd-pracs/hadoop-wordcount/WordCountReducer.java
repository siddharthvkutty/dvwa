import java.io.IOException;


import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;


public class WordCountReducer
        extends Reducer<Text, IntWritable, Text, IntWritable> {


    @Override
    public void reduce(
            Text key,
            Iterable<IntWritable> values,
            Context context)
            throws IOException, InterruptedException {


        int sum = 0;


        // Sum all values (1s) for the given key (word)
        for (IntWritable val : values) {
            sum += val.get();
        }


        // Emit (word, sum)
        context.write(key, new IntWritable(sum));
    }
}
