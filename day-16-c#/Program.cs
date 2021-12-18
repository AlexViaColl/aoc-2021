using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

class Program {
    public static void Main(string[] args) {
        foreach (var arg in args) {
            try {
                using (var stream = new StreamReader(arg)) {
                    string input = stream.ReadToEnd();
                    string bits = String.Join(String.Empty, input.Select(
                        c => Convert.ToString(Convert.ToInt32(c.ToString(), 16), 2).PadLeft(4, '0')
                    ));

                    (int index, var packet) = parse_packet(bits, 0);

                    Console.WriteLine("Part 1: {0}", version_sum(packet!));
                    Console.WriteLine("Part 2: {0}", calculate(packet!));
                }
            } catch (IOException e) {
                Console.WriteLine("The file could not be read:");
                Console.WriteLine(e.Message);
            }
        }
    }

    static (int, Packet?) parse_packet(String bits, int index) {
        Packet? packet = null;
        if (bits.Substring(index).Length < 6 || bits.All(c => c == '0')) {
            return (index, packet);
        }

        int version = Convert.ToInt32(bits.Substring(index, 3), 2);
        // Console.WriteLine("Version {0}", version);
        index += 3;

        int type_id = Convert.ToInt32(bits.Substring(index, 3), 2);
        // Console.WriteLine("type id: {0}", type_id);
        index += 3;

        if (type_id == 4) {
            long literal = 0;
            while (true) {
                String part = bits.Substring(index, 5);
                index += 5;

                literal = literal << 4 | Convert.ToInt64(part.Substring(1), 2);

                if (part[0] == '0') {
                    break;
                }
            }
            // Console.WriteLine("Literal {0}", literal);
            packet = new Packet(version, type_id, literal);
        } else {
            int length_type_id = Convert.ToInt32(bits.Substring(index, 1), 2);
            index += 1;

            if (length_type_id == 0) {
                int length_in_bits = Convert.ToInt32(bits.Substring(index, 15), 2);
                index += 15;

                String subpacket_bits = bits.Substring(index, length_in_bits);

                List<Packet> subpackets = new List<Packet>();
                int sub_index = 0;
                while (true) {
                    (int new_index, var subpacket) = parse_packet(subpacket_bits, sub_index);
                    sub_index = new_index;

                    if (subpacket == null) {
                        break;
                    }

                    subpackets.Add(subpacket);
                }

                index += length_in_bits;

                packet = new Packet(version, type_id, subpackets);
            } else {
                int subpackets_count = Convert.ToInt32(bits.Substring(index, 11), 2);
                index += 11;
                List<Packet> subpackets = new List<Packet>();
                for (int i = 0; i < subpackets_count; i++) {
                    (int new_index, var subpacket) = parse_packet(bits, index);
                    index = new_index;
                    subpackets.Add(subpacket!);
                }
                packet = new Packet(version, type_id, subpackets);
            }
        }

        return (index, packet);
    }

    static long version_sum(Packet packet) {
        if (packet.type_id == 4) {
            return packet.version;
        } else {
            long sum = packet.version;
            foreach (Packet subpacket in packet.payload.subpackets) {
                sum += version_sum(subpacket);
            }
            return sum;
        }
    }

    static long calculate(Packet packet) {
        switch (packet.type_id) {
            case 4: return packet.payload.literal;

            case 0: { // sum
                long sum = 0;
                foreach (var subpacket in packet.payload.subpackets) {
                    sum += calculate(subpacket);
                }
                return sum;
            }
            case 1: { // prod
                long prod = 1;
                foreach (var subpacket in packet.payload.subpackets) {
                    prod *= calculate(subpacket);
                }
                return prod;
            }
            case 2: { // min
                return packet.payload.subpackets.Min(p => calculate(p));
            }
            case 3: { // max
                return packet.payload.subpackets.Max(p => calculate(p));
            }
            case 5: { // greater than
                return calculate(packet.payload.subpackets[0]) > calculate(packet.payload.subpackets[1]) ? 1 : 0;
            }
            case 6: { // less than
                return calculate(packet.payload.subpackets[0]) < calculate(packet.payload.subpackets[1]) ? 1 : 0;
            }
            case 7: { // equal
                return calculate(packet.payload.subpackets[0]) == calculate(packet.payload.subpackets[1]) ? 1 : 0;
            }
            default: throw new Exception("zzz");
        }
    }
}

class Packet {
    public int version;
    public int type_id;
    public Payload payload;

    public Packet(int version, int type_id, long literal) {
        this.version = version;
        this.type_id = type_id;
        this.payload = new Payload(literal);
    }

    public Packet(int version, int type_id, List<Packet> subpackets) {
        this.version = version;
        this.type_id = type_id;
        this.payload = new Payload(type_id, subpackets);
    }
}

class Payload {
    public long literal;
    public int op;
    public List<Packet> subpackets = new List<Packet>();

    public Payload(long literal) {
        this.op = 4;
        this.literal = literal;
    }

    public Payload(int op, List<Packet> subpackets) {
        this.op = op;
        this.subpackets = subpackets;
    }
}