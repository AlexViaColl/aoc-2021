let read_whole_file filename =
    let ch = open_in filename in
    let s = really_input_string ch (in_channel_length ch) in
    close_in ch;
    s;;

let string_to_char_list s = List.init (String.length s) (String.get s);;
  
let rec transpose xss =
    match xss with
    | [] -> []
    | []::_ -> []
    | _ -> List.map List.hd xss :: transpose (List.map List.tl xss);;

let part_1 input =
    let lines = String.split_on_char '\n' input in
    let columns = transpose (List.map string_to_char_list lines) in

    let gamma_bits = List.map (fun col -> if List.length(List.filter (fun c -> c = '1') col) >= List.length col / 2
                                then '1'
                                else '0') columns in
    let epsilon_bits = List.map (fun col -> if List.length(List.filter (fun c -> c = '1') col) >= List.length col / 2
                                then '0'
                                else '1') columns in
    
    let gamma_bits_str = String.of_seq (List.to_seq gamma_bits) in
    let epsilon_bits_str = String.of_seq (List.to_seq epsilon_bits) in

    let gamma = int_of_string ("0b" ^ gamma_bits_str) in
    let epsilon = int_of_string ("0b" ^ epsilon_bits_str) in
    gamma * epsilon;;

let get_most_freq lines first second =
    let columns = transpose (List.map string_to_char_list lines) in
    let num_ones = List.map (fun col -> (List.length (List.filter (fun c -> c = '1') col))) columns in
    let num_zeros = List.map (fun col -> (List.length (List.filter (fun c -> c = '0') col))) columns in
    List.map (fun el -> let (a, b) = el in if a >= b then first else second) (List.combine num_ones num_zeros);;

let rec filter_lines lines index first second =
    if (List.length lines) = 1 then List.hd lines
    else
        let most_freq = get_most_freq lines first second in
        let new_lines = List.filter (fun line -> (String.get line index) = (List.nth most_freq index)) lines in
        filter_lines new_lines (index + 1) first second;;

let part_2 input =
    let lines = String.split_on_char '\n' input in
    let oxygen = int_of_string ("0b" ^ (filter_lines lines 0 '1' '0')) in
    let co2 = int_of_string ("0b" ^ (filter_lines lines 0 '0' '1')) in
    oxygen * co2;;

let input = read_whole_file Sys.argv.(1);;
print_string ("Part 1: " ^ (string_of_int (part_1 input)) ^ "\n");
print_string ("Part 2: " ^ (string_of_int (part_2 input)) ^ "\n")