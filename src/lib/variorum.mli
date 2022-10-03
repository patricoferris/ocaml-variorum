(** OCaml bindings to the C-library Variorum. This provides
    hardward locality and power information for many different
    architeectures with a single unified interface.

    For more information, including the kinds of extra setup procedures
    you might have to do to get things working, please visit their
    excellent {{: https://variorum.readthedocs.io/} documentation site}. *)

(** {2 Printing Functions}

    For more information about these function please visit the
    {{: https://variorum.readthedocs.io/en/latest/api/print_functions.html} print_functions documentation page}. This includes helpful information like supported architectures for each function.
*)

val supported : bool
(** Whether the implementation will return values or are [Undefined] *)

val print_power_limit : unit -> (unit, [ `Msg of string ]) result
(** Print power limits for all known domains *)

val print_thermals : unit -> (unit, [ `Msg of string ]) result
(** Print thermal information *)

val print_counters : unit -> (unit, [ `Msg of string ]) result
(** Print performance counters *)

val print_power : unit -> (unit, [ `Msg of string ]) result
(** Print power and energy usage *)

val print_hyperthreading : unit -> (unit, [ `Msg of string ]) result
(** Print if hyperthreading is enabled *)

val print_topology : unit -> unit
(** Print the hardware topology *)

val print_energy : unit -> (unit, [ `Msg of string ]) result
(** Print if core and socket energy is available *)

(** {2 Topology Functions} 

    Topology functions provide high-level access to the hwloc API.
    See {{: https://variorum.readthedocs.io/en/latest/api/advanced_topology_functions.html} this documentation page for more information}.
*)

val get_num_of_sockets : unit -> (int, [ `Msg of string ]) result
(** The number of sockets on the hardware platform *)

val get_num_cores : unit -> (int, [ `Msg of string ]) result
(** The number of cores on the hardward platform *)

val get_num_threads : unit -> (int, [ `Msg of string ]) result
(** The number of threads on the hardware platform *)

module Node_power : sig
  type t

  val hostname : t -> string
  val timestamp : t -> float
  val power_node : t -> float
  val num_sockets : t -> int
  val power_cpu_watts_socket : t -> float list
  val power_mem_watts_socket : t -> float list
  val power_gpu_watts_socket : t -> float list
  val to_json : t -> Ezjsonm.value
  val of_json : Ezjsonm.value -> (t, [ `Msg of string ]) result

  val get : unit -> (t, [ `Msg of string ]) result
  (** Returns the node power information as a JSON string *)

  val get_domain_info : unit -> (string, [ `Msg of string ]) result
  (** Returns the domain information as a JSON string *)
end

(** {2 Capping functions } *)

val cap_each_core_frequency_limit : int -> (unit, [ `Msg of string ]) result
(** Cap the CPU frequency for all cores within a socket to a given amount of mhz. *)
