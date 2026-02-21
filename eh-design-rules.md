struct Container {
    children: collection [eh],
    routingTable : collection [Wire {direction, sender, children} ]
                                     where sender is in children or is self, receiver is in children or is self
}


subr container-handler (eh, mev) {
    where: eh is a Container
    where: mev is a Mevent
}
