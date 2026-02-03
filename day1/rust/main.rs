use std::fs::File;
use std::path::Path;
use std::io::{self};
//use meval::eval_str;

fn main() -> io::Result<()> {
    let file_path = Path::new("../input.txt"); 

    // Open the file, handling potential errors
    // Create a BufReader for efficient line-by-line reading
    //  let reader = BufReader::new(file); 
    let position = 0;

        if let Ok(lines) = read_lines(file_path) {
        for line in lines {
            if let Ok(data) = line {
                // slice string, this could be improved for multi-byte chars 
                let operator = &data[0];
                let number = &data[1..];
                println!("Original: {}, Sliced: {}", operator, number);
            }
        }
        }
        Ok(())
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
