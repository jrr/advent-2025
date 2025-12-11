import gleam/bool
import gleam/dict
import gleam/io
import gleam/list
import gleam/pair
import gleam/set
import gleam/string

pub fn main() -> Nil {
  io.println_error("Hello from advent!")
}

pub fn parse(input: String) {
  input
  |> string.split("\n")
  |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })
  |> list.map(parse_line)
  |> dict.from_list
}

pub fn parse_line(s: String) -> #(String, List(String)) {
  let assert Ok(#(left, right)) = string.split_once(s, on: ":")

  let right_vals =
    right
    |> string.split(" ")
    |> list.filter(fn(x) { bool.negate(string.is_empty(x)) })

  #(left, right_vals)
}

type ConnectivityMap =
  dict.Dict(String, List(String))

pub fn reverse_dict(input: ConnectivityMap) -> ConnectivityMap {
  let what =
    input
    |> dict.to_list
    |> list.flat_map(fn(p) { p.1 |> list.map(fn(q) { #(q, p.0) }) })
  let g =
    what
    |> list.group(fn(x) { x.0 })
    |> dict.map_values(fn(a, b) { b |> list.map(pair.second) })

  let targets = input |> dict.values |> list.flatten |> set.from_list
  let sources = input |> dict.keys |> set.from_list
  let leftovers = set.difference(sources, targets) |> set.to_list
  let entries = leftovers |> list.map(fn(x) { #(x, []) }) |> dict.from_list
  let together = dict.combine(g, entries, fn(a, b) { list.append(a, b) })
  together
}

pub type NodeCount {
  NodeCount(
    num_paths_to_here: Int,
    num_paths_with_fft: Int,
    num_paths_with_dac: Int,
    num_paths_with_fft_and_dac: Int,
  )
}

pub fn find_entries(connectivity: ConnectivityMap) -> List(String) {
  connectivity
  |> reverse_dict
  |> dict.to_list
  |> list.filter(fn(x) { list.is_empty(x.1) })
  |> list.map(pair.first)
}

pub fn solve1(input: String, start_node: String, end_node: String) -> NodeCount {
  let connectivity = input |> parse

  let cleaned_tree: ConnectivityMap = clean_tree(connectivity, start_node)

  let final_counts = recurse(cleaned_tree, dict.new())

  let x = final_counts |> dict.get(end_node)
  case x {
    Ok(n) -> n
    _ -> panic
  }
}

pub fn clean_tree(
  connectivity: dict.Dict(String, List(String)),
  entry_to_keep: String,
) -> dict.Dict(String, List(String)) {
  let entries =
    connectivity |> find_entries |> list.filter(fn(n) { n != entry_to_keep })
  case entries {
    [] -> connectivity
    x -> {
      let without_nodes = connectivity |> dict.drop(x)
      clean_tree(without_nodes, entry_to_keep)
    }
  }
}

fn recurse(
  connectivity: dict.Dict(String, List(String)),
  counts: CountDict,
) -> CountDict {
  let entries = connectivity |> find_entries

  let #(new_connectivity, new_count) =
    entries
    |> list.fold(#(connectivity, counts), fn(a, node_name) {
      let #(connectivity, counts) = a
      consume_node(counts, connectivity, node_name)
    })

  case new_connectivity |> dict.size {
    0 -> new_count
    _ -> recurse(new_connectivity, new_count)
  }
}

type CountDict =
  dict.Dict(String, NodeCount)

fn consume_node(
  counts: CountDict,
  connectivity: ConnectivityMap,
  start_node: String,
) -> #(ConnectivityMap, CountDict) {
  let target_nodes = case connectivity |> dict.get(start_node) {
    Ok(x) -> x
    Error(_) -> []
  }
  let remaining_connectivity = connectivity |> dict.drop([start_node])

  // io.println_error("== Node '" <> start_node <> "' ===")

  let updated_counts =
    target_nodes
    |> list.fold(counts, fn(accum_counts, target_node_name) {
      let source_node = accum_counts |> dict.get(start_node)
      let node_count = case source_node {
        Error(_) -> {
          NodeCount(
            num_paths_to_here: 1,
            num_paths_with_dac: 0,
            num_paths_with_fft: 0,
            num_paths_with_fft_and_dac: 0,
          )
        }

        Ok(node_count) -> {
          let this_node_fft = [start_node] |> list.count(fn(s) { s == "fft" })
          let this_node_dac = [start_node] |> list.count(fn(s) { s == "dac" })

          NodeCount(
            ..node_count,
            num_paths_with_dac: node_count.num_paths_with_dac
              + node_count.num_paths_to_here
              * this_node_dac,
            num_paths_with_fft: node_count.num_paths_with_fft
              + node_count.num_paths_to_here
              * this_node_fft,
            num_paths_with_fft_and_dac: node_count.num_paths_with_fft_and_dac
              + node_count.num_paths_with_dac
              * this_node_fft
              + node_count.num_paths_with_fft
              * this_node_dac,
          )
        }
      }

      increment_count(accum_counts, target_node_name, node_count)
    })

  #(remaining_connectivity, updated_counts)
}

fn increment_count(
  counts: dict.Dict(String, NodeCount),
  start_node: String,
  incoming_counts: NodeCount,
) {
  let updates = [#(start_node, incoming_counts)] |> dict.from_list

  dict.combine(counts, updates, fn(a, b) {
    NodeCount(
      num_paths_to_here: a.num_paths_to_here + b.num_paths_to_here,
      num_paths_with_dac: a.num_paths_with_dac + b.num_paths_with_dac,
      num_paths_with_fft: a.num_paths_with_fft + b.num_paths_with_fft,
      num_paths_with_fft_and_dac: a.num_paths_with_fft_and_dac
        + b.num_paths_with_fft_and_dac,
    )
  })
}
