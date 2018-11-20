class DistanceComparator implements Comparator<Observation> {
  ICanSense center;

  DistanceComparator(ICanSense _center) {
    center = _center;
  }

  int compare(Observation a, Observation b) {
    float dB = center.distanceTo(a);
    float dA = center.distanceTo(b);
    return int(dB - dA);
  }
}
